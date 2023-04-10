import SwiftUI
import AVFAudio

struct AddDocument: View {
    @EnvironmentObject var mix: MixData
    
    var id: String
    var fileURL: Data?
    
    func initAudio(file: URL, withPause: Bool) {
        let checkPerm = file.startAccessingSecurityScopedResource()
        if(checkPerm) {
            do {
                let audio = try AVAudioPlayer(contentsOf: file)
                mix.initFile(file: file, uuid: id, audio: audio, pauseBefore: withPause)
            } catch {
                initAudioFailed = true
                file.stopAccessingSecurityScopedResource()
            }
        } else {
            filePermissionsFailed = true
            file.stopAccessingSecurityScopedResource()
        }
    }
    
    @State private var importing = false
    @State private var importedFailed = false
    @State private var filePermissionsFailed = false
    @State private var initAudioFailed = false
    @State private var isPlayingAlert = false
    @State private var importedFile: URL!
    @State private var isPlayingBefore = false
    
    var body: some View {
        Button(action: {
            importing = true
        }, label: {
            Image(systemName: (fileURL != nil) ? "waveform.circle.fill" : "waveform.path.badge.plus")
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(.white)
        })
        .frame(width: 125, height: 50, alignment: .center)
        .background(Color.init(white: 0.1))
        .fileImporter(isPresented: $importing,
                      allowedContentTypes: [.audio],
                      allowsMultipleSelection: false
        ) {
            result in
            if case .success = result {
                do {
                    importedFile = try result.get().first!
                    if(mix.players.paused == false) {
                        if !mix.players.paused {
                            mix.timer.stop()
                            isPlayingBefore.toggle()
                        }
                        isPlayingAlert = true
                    } else {
                        initAudio(file: importedFile, withPause: false)
                    }
                } catch {
                    importedFailed = true
                }
            } else {
                importedFailed = true
            }
        }.alert(isPresented: $importedFailed) {
            Alert(title: Text("Import Failed"))
        }.alert(isPresented: $filePermissionsFailed) {
            Alert(title: Text("Permissions Failed"), message: Text("Failed to access the audio file"))
        }.alert(isPresented: $initAudioFailed) {
            Alert(title: Text("Audio Init Failed"), message: Text("Failed to initialize the audio player"))
        }
        .alert(isPresented: $isPlayingAlert) {
            Alert(title: Text("New Audio Loaded"), message: Text("Please continue to refresh the player"), primaryButton: .cancel({
                if isPlayingBefore {
                    mix.startTimer()
                    isPlayingBefore.toggle()
                }
            }), secondaryButton: .default(Text("Continue")){
                initAudio(file: importedFile, withPause: true)
            })
        }.onAppear {
            if(mix.isUserDefaultsLoaded) {
                if(fileURL != nil) {
                    var isStale = false
                    do {
                        let url = try URL(resolvingBookmarkData: fileURL!, bookmarkDataIsStale: &isStale)
                        if(isStale == false){
                            initAudio(file: url, withPause: false)
                        }
                    }catch {
                        print("Failed to get the bookmark data")
                    }
                }
            }
        }
    }
}

