/// MusicEngine.swift
/// SNES-style chiptune music using AVAudioEngine + PCM buffer generation.
/// No external dependencies — pure AVFoundation.
///
/// Approach:
///   • Pre-computes an AVAudioPCMBuffer for each theme (a few seconds that loops).
///   • Melody voice: square wave  (classic SNES PSG feel)
///   • Bass voice:   triangle wave (SNES SPC700 triangle channel)
///   • Simple note/rest patterns, one 16th note per step at 108 BPM.

import AVFoundation
import Foundation

final class MusicEngine {
    
    static let shared = MusicEngine()
    
    enum Theme: Equatable {
        case title, overworld, battle, victory
    }
    
    private let engine      = AVAudioEngine()
    private let playerNode  = AVAudioPlayerNode()
    private var currentTheme: Theme?
    private let sampleRate: Double = 44100
    private let bpm: Double = 108
    
    private init() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: nil)
    }
    
    // MARK: - Public API
    
    func play(theme: Theme) {
        guard theme != currentTheme else { return }
        stop()
        currentTheme = theme
        
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
        } catch {
            print("[MusicEngine] Engine start failed: \(error)")
            return
        }
        
        guard let buffer = makeBuffer(for: theme) else {
            print("[MusicEngine] Buffer creation failed for theme \(theme)")
            return
        }
        
        playerNode.play()
        playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
    }
    
    func stop() {
        playerNode.stop()
        if engine.isRunning { engine.stop() }
        currentTheme = nil
    }
    
    // MARK: - Buffer generation
    
    /// Pre-compute a looping PCM buffer for the given theme.
    private func makeBuffer(for theme: Theme) -> AVAudioPCMBuffer? {
        guard let format = AVAudioFormat(
            standardFormatWithSampleRate: sampleRate, channels: 2) else { return nil }
        
        let stepsPerBeat  = 4                                         // 16th-note steps
        let beatDuration  = 60.0 / bpm
        let stepDuration  = beatDuration / Double(stepsPerBeat)
        let samplesPerStep = Int(sampleRate * stepDuration)
        
        let (melodyPattern, bassPattern) = notePatterns(for: theme)
        let totalSteps   = melodyPattern.count
        let totalSamples = totalSteps * samplesPerStep
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: format, frameCapacity: AVAudioFrameCount(totalSamples)) else { return nil }
        buffer.frameLength = AVAudioFrameCount(totalSamples)
        
        guard let leftCh  = buffer.floatChannelData?[0],
              let rightCh = buffer.floatChannelData?[1] else { return nil }
        
        var melodyPhase = 0.0
        var bassPhase   = 0.0
        let fadeSamples = min(400, samplesPerStep / 4)
        
        for step in 0..<totalSteps {
            let mFreq = melodyPattern[step]
            let bFreq = bassPattern[step % bassPattern.count]
            let startIdx = step * samplesPerStep
            
            for s in 0..<samplesPerStep {
                // Per-note amplitude envelope (short attack/release = chiptune click-free)
                let envelope: Float
                if s < fadeSamples {
                    envelope = Float(s) / Float(fadeSamples)
                } else if s > samplesPerStep - fadeSamples {
                    envelope = Float(samplesPerStep - s) / Float(fadeSamples)
                } else {
                    envelope = 1.0
                }
                
                // Melody: square wave at ±0.28
                var melodySample: Float = 0
                if mFreq > 0 {
                    melodyPhase += 2.0 * .pi * mFreq / sampleRate
                    if melodyPhase >= 2.0 * .pi { melodyPhase -= 2.0 * .pi }
                    melodySample = (melodyPhase < .pi ? 0.28 : -0.28) * envelope
                } else {
                    melodyPhase = 0
                }
                
                // Bass: triangle wave at ±0.14 (softer than melody)
                var bassSample: Float = 0
                if bFreq > 0 {
                    bassPhase += 2.0 * .pi * bFreq / sampleRate
                    if bassPhase >= 2.0 * .pi { bassPhase -= 2.0 * .pi }
                    let norm = Float(bassPhase / (2.0 * .pi))   // 0…1
                    bassSample = (norm < 0.5 ? (4.0 * norm - 1.0) : (3.0 - 4.0 * norm)) * 0.14 * envelope
                } else {
                    bassPhase = 0
                }
                
                let sample = melodySample + bassSample
                leftCh[startIdx + s]  = sample
                rightCh[startIdx + s] = sample
            }
        }
        
        return buffer
    }
    
    // MARK: - Note patterns (frequencies in Hz; 0 = rest)
    
    private func notePatterns(for theme: Theme) -> ([Double], [Double]) {
        
        // Octave 2 (bass)
        let C2: Double  = 65.41
        let G2: Double  = 98.00
        let A2: Double  = 110.00
        let Bb2: Double = 116.54
        let D3: Double  = 146.83
        let E3: Double  = 164.81
        let F3: Double  = 174.61
        let G3: Double  = 196.00
        let A3: Double  = 220.00
        let B3: Double  = 246.94
        let C3: Double  = 130.81

        // Octave 4 (melody)
        let C4: Double  = 261.63
        let D4: Double  = 293.66
        let E4: Double  = 329.63
        let F4: Double  = 349.23
        let G4: Double  = 392.00
        let A4: Double  = 440.00
        let Bb4: Double = 466.16
        let B4: Double  = 493.88
        let C5: Double  = 523.25
        let D5: Double  = 587.33
        let E5: Double  = 659.25
        let G5: Double  = 783.99
        let R: Double   = 0   // rest
        
        // Suppress unused-variable warnings for notes not in every theme
        _ = (C2, G2, A2, Bb2, D3, E3, F3, G3, A3, B3, C3,
             C4, D4, E4, F4, G4, A4, Bb4, B4, C5, D5, E5, G5)
        
        switch theme {
            
        // MARK: Title — solemn, hymn-like in C major
        case .title:
            let melody: [Double] = [
                // Bar 1
                G4, G4,  R, G4, G4, A4, G4,  R,
                // Bar 2
                E4, E4,  R, E4, F4, E4, D4,  R,
                // Bar 3
                C4, C4, C4, E4, G4, G4,  R,  R,
                // Bar 4
                A4, A4, G4, F4, E4,  R, C5,  R
            ]
            let bass: [Double] = [
                C3,  R, C3,  R, G3,  R, G3,  R,
                A3,  R, A3,  R, F3,  R, F3,  R,
                C3,  R, C3,  R, G3,  R, G3,  R,
                F3,  R, F3,  R, C3,  R, C3,  R
            ]
            return (melody, bass)
            
        // MARK: Overworld — bright, hopeful arpeggio exploration theme
        case .overworld:
            let melody: [Double] = [
                // Bar 1 — C major ascending
                C4, E4, G4, C5, G4, E4, C4,  R,
                // Bar 2 — Am ascending
                A4, C5, E5, A4, E5, C5, A4,  R,
                // Bar 3 — F major
                F4, A4, C5, F4, C5, A4, F4,  R,
                // Bar 4 — G7 back to C
                G4, B4, D5, G4, D5, B4, G4,  R
            ]
            let bass: [Double] = [
                C3,  R, G3,  R, C3,  R, G3,  R,
                A3,  R, E3,  R, A3,  R, E3,  R,
                F3,  R, C3,  R, F3,  R, C3,  R,
                G3,  R, D3,  R, G3,  R, D3,  R
            ]
            return (melody, bass)
            
        // MARK: Battle — urgent, driving, minor-key tension
        case .battle:
            let melody: [Double] = [
                // Bar 1
                E4, E4,  R, E5,  R, E4, D4,  R,
                // Bar 2
                E4, E4,  R, E5,  R, D4, C4,  R,
                // Bar 3
                E4, G4, E4, G4, E5, G4, E4,  R,
                // Bar 4
                D4, F4, D4, F4, D5, C4,  R,  R
            ]
            let bass: [Double] = [
                A3,  R, A3, E3, A3,  R, E3,  R,
                A3,  R, A3, E3, G3,  R, E3,  R,
                A3, E3, A3, E3, A3, E3, A3,  R,
                F3,  R, F3,  R, E3,  R, E3,  R
            ]
            return (melody, bass)
            
        // MARK: Victory — triumphant fanfare in C major
        case .victory:
            let melody: [Double] = [
                // Bar 1
                C4, E4, G4, C5,  R, C5, B4, A4,
                // Bar 2
                G4, A4,  R, G4, E4, G4, C5,  R,
                // Bar 3
                E5, E5, D5, C5, B4, A4, G4,  R,
                // Bar 4 — final resolution
                C5, G4, E4, C4,  R,  R,  R,  R
            ]
            let bass: [Double] = [
                C3,  R, G3,  R, C3,  R, G3,  R,
                F3,  R, F3,  R, G3,  R, G3,  R,
                C3,  R, C3,  R, G3,  R, E3,  R,
                F3,  R, C3,  R, G3,  R, C3,  R
            ]
            return (melody, bass)
        }
    }
}
