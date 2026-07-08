import Foundation
import MediaPlayer

final class RemoteCommandHandler {
    var onPlayPause: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?
    
    init() {
        setupRemoteCommands()
    }
    
    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.onPlayPause?()
            return .success
        }
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.onPlayPause?()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.onPlayPause?()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.onNext?()
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.onPrevious?()
            return .success
        }
    }
    
    func disable() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.removeTarget(self)
        commandCenter.playCommand.removeTarget(self)
        commandCenter.pauseCommand.removeTarget(self)
        commandCenter.nextTrackCommand.removeTarget(self)
        commandCenter.previousTrackCommand.removeTarget(self)
    }
}
