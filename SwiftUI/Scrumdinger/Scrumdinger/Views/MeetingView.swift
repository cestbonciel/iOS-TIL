//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Seohyun Kim on 2023/07/23.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
	@Binding var scrum: DailyScrum
	//Property 를 @StateObject 로 감싸는 것은 뷰가 객체에 대한 정보 소스를 소유한다는 것을 의미
	@StateObject var scrumTimer = ScrumTimer()
	@StateObject var speechRecognizer = SpeechRecognizer()
	@State private var isRecording = false
	 
	private var player: AVPlayer { AVPlayer.sharedDingPlayer }
	
    var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 16.0)
				.fill(scrum.theme.mainColor)
			VStack {
				MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
				MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
				MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
			}
			.padding()
			.foregroundColor(scrum.theme.accentColor)
			.onAppear {
				startScrum()
			}
			.onDisappear {
				endScrum()
			}
			.navigationBarTitleDisplayMode(.inline)
		}
    }
	
	private func startScrum() {
		scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
		scrumTimer.speakerChangedAction = {
			player.seek(to: .zero)
			player.play()
		}
		speechRecognizer.resetTranscript()
		speechRecognizer.startTranscribing()
		isRecording = true
		scrumTimer.startScrum()
	}
	
	private func endScrum() {
		scrumTimer.stopScrum()
		speechRecognizer.stopTranscribing()
		isRecording = false
		let newHistory = History(attendees: scrum.attendees, transcript: speechRecognizer.transcript)
		scrum.history.insert(newHistory, at: 0)
	}    
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
		MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
