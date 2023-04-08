import Foundation
import SwiftUI
import AVFAudio


class MixData: ObservableObject {
    @AppStorage("storedMixData") var storage = ""
    @AppStorage("isTutorialToggled") var tutorial = true
    
    var timer = FetchTimer()
    var isUserDefaultsLoaded = false
    
    private var syncIdx: Int?
    
    @Published var data: [MixControl] {
        didSet {
            saveData()
        }
    }
    @Published var players = AudioPlayer()
    @Published var selectedTrack: String? = nil
    
    init() {
        if let storedData = UserDefaults.standard.data(forKey: "storedMixData") {
            if let decodedData = try? JSONDecoder().decode([MixControl].self, from: storedData) {
                data = decodedData
                isUserDefaultsLoaded = true
                return
            }
        }
        data = [MixControl(0)]
    }
    
    // --------------------------- Tutorial Management -----------------------------------------------
    
    func showTutorial() {
        UserDefaults.standard.set(true, forKey: "isTutorialToggled")
        tutorial = true
    }
    
    func dismissTutorial() {
        UserDefaults.standard.set(false, forKey: "isTutorialToggled")
        tutorial = false
    }
    
    // --------------------------- Array Utilities -----------------------------------------------
    
    private func getDataFromUUID(_ uuid: String) -> Int? {
        var idx: Int?
        for index in 0..<data.count {
            let comparison = data[index]
            if comparison.id == uuid {
                idx = index
                break
            }
        }
        return idx
    }
    
    private func getPlayerFromUUID(_ uuid: String) -> Int? {
        var idx: Int?
        for index in 0..<players.player.count {
            let comparison = players.player[index]
            if comparison.id == uuid {
                idx = index
                break
            }
        }
        return idx
    }
    
    // --------------------------- Audio Utilities -----------------------------------------------
    
    func dBToPower(_ db: Float) -> Float {
        let db = roundf(db * 10) / 10.0
        return pow(10, db / 10)
    }
    
    // --------------------------- Mixer management -----------------------------------------------
    
    func addTrack() {
        data.append(MixControl(data.count))
    }
    
    func deleteTrack() {
        let dataIdx = getDataFromUUID(selectedTrack!)
        if dataIdx != nil {
            pauseProcess(statePaused: true)
            let playerIdx = getPlayerFromUUID(selectedTrack!)
            if(playerIdx != nil) {
                if(selectedTrack == players.player[playerIdx!].id) {
                    players.syncTime.time = nil
                }
                players.player.remove(at: playerIdx!)
            }
            data.remove(at: dataIdx!)
        }
    }
    
    func resetData() {
        pause()
        data = [MixControl(0)]
        players = AudioPlayer()
        UserDefaults.standard.set("", forKey: "storedMixData")
    }
    
    // --------------------------- File Management -----------------------------------------------
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "storedMixData")
        }
    }
    
    func initFile(file: URL, uuid: String, audio: AVAudioPlayer, pauseBefore: Bool) {
        if(pauseBefore) {
            pauseProcess(statePaused: true)
        }
        do {
            let dataIdx = getDataFromUUID(uuid)
            if(dataIdx != nil) {
                do {
                    _ = file.startAccessingSecurityScopedResource()
                    let bookmark = try file.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                    
                    data[dataIdx!].url = bookmark
                    
                    file.stopAccessingSecurityScopedResource()
                    
                    audio.volume = dBToPower(data[dataIdx!].gain)
                    audio.prepareToPlay()
                    audio.isMeteringEnabled = true
                    
                    var playerIdx = getPlayerFromUUID(uuid)
                    if(playerIdx != nil) {
                        players.player[playerIdx!].node = audio
                    } else {
                        players.player.append(Player(id: uuid, node: audio))
                        playerIdx = getPlayerFromUUID(uuid)
                    }
                    if(players.syncTime.time ?? 0 < audio.duration) {
                        players.syncTime.uuid = uuid
                        players.syncTime.time = audio.duration
                    }
                } catch {
                    print("Save Failed")
                }
            }
        }
        if(pauseBefore) {
            play(throwNoAudio: {})
        }
    }
    
    // --------------------------- Audio Player -----------------------------------------------
    
    func getAmplitude(id: String) -> Float {
        let dataIdx = getDataFromUUID(id)
        let playerIdx = getPlayerFromUUID(id)
        
        if(dataIdx != nil && playerIdx != nil) {
            return dBToPower(players.player[playerIdx!].currentdB) * dBToPower(data[dataIdx!].gain)
        } else {
            return 0
        }
    }
    
    func setVolume(gain: Float, id: String) {
        let playerIdx = getPlayerFromUUID(id)
        if(playerIdx != nil) {
            if(gain == -70.0) {
                players.player[playerIdx!].node?.setVolume(0, fadeDuration: 0)
            } else {
                players.player[playerIdx!].node?.setVolume(dBToPower(gain), fadeDuration: 0)
            }
        }
    }
    
    private func pauseProcess(statePaused: Bool?) {
        self.timer.stop()
        if(statePaused == true) {
            self.players.paused = true
        }
        for track in self.players.player {
            if(track.node != nil) {
                track.node?.pause()
            }
            let playerIdx = self.getPlayerFromUUID(track.id)
            self.players.player[playerIdx!].currentdB = -70
        }
    }
    
    func startTimer() {
        timer.start(timeInterval: 0.05) {
            if(self.players.paused == false) {
                
                //---------- Update Current PlayTime ----------//
                
                let currentTime = self.players.player[self.syncIdx!].node?.currentTime
                if(currentTime != nil) {
                    self.players.syncTime.current = currentTime!
                }
                
                //---------- Check Playing ----------//
                
                let isPlaying = self.players.player[self.syncIdx!].node?.isPlaying
                if(isPlaying == false) {
                    self.players.paused = true
                }
                
                //---------- Assign Current dB ----------//
                
                for track in self.players.player {
                    let playerIdx = self.getPlayerFromUUID(track.id)
                    self.players.player[playerIdx!].node?.updateMeters()
                    self.players.player[playerIdx!].currentdB = (self.players.player[playerIdx!].node?.averagePower(forChannel: 0))!
                }
            } else {
                self.pauseProcess(statePaused: true)
            }
        }
    }
    
    func play(throwNoAudio: () -> Void) {
        if(players.player.first?.node == nil) {
            throwNoAudio()
            return
        }
        if(players.paused == false){
            return
        }
        
        //----------------- Get Sync Time -----------------//
        
        if(players.syncTime.time == nil) {
            for audio in players.player {
                if(players.syncTime.time ?? 0 < audio.node?.duration ?? 0 ) {
                    players.syncTime.uuid = audio.id
                    players.syncTime.time = audio.node?.duration
                }
            }
        }
        
        //----------------- Play -----------------//
        
        let firstNodeTime = players.player.first?.node?.deviceCurrentTime
        if(firstNodeTime != nil) {
            let syncTime = firstNodeTime! + 0.25
            for mixer in players.player {
                if(mixer.node?.duration ?? 0 > players.syncTime.current) {
                    mixer.node?.currentTime = players.syncTime.current
                    mixer.node?.play(atTime: syncTime)
                }
                players.paused = false
            }
        }
        
        //----------------- Sync Process -----------------//
        
        syncIdx = getPlayerFromUUID(players.syncTime.uuid!)
        
        
        if(syncIdx != nil) {
            startTimer()
        }
    }
    
    func pause() {
        if(players.paused == false) {
            for mixer in players.player {
                if(mixer.node != nil) {
                    mixer.node?.pause()
                }
            }
            players.paused = true
        } else {
            for mixer in players.player {
                if(mixer.node != nil) {
                    mixer.node?.stop()
                    players.syncTime.current = 0
                }
            }
        }
    }
    
}
