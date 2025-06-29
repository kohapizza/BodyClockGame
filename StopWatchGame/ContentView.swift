//
//  ContentView.swift
//  StopWatchGame
//
//  Created by 佐伯小遥 on 2025/06/29.
//

import SwiftUI

struct ContentView: View {
    @State private var targetTime: Double = 5.0
    @State private var timer: Timer?
    @State private var secondsElapsed: Double = 0.0
    @State private var isRunning: Bool = false
    @State private var showResult: Bool = false
    @State private var resultMessage: String = ""
    @State private var resultColor: Color = .black
    @State private var resultScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("体内時計チャレンジ")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                }
                .padding(.top)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("目標タイム")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(String(format: "%.0f", targetTime)) 秒")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    if !showResult && !isRunning {
                        Slider(value: $targetTime, in: 5...30, step: 1)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 30) {
                    if showResult {
                        Text(resultMessage)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(resultColor)
                            .multilineTextAlignment(.center)
                            .scaleEffect(resultScale)
                            .onAppear {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.3)) {
                                    resultScale = 1.2
                                }
                            }
                    }
                    
                    if isRunning {
                        VStack(spacing: 25) {
                            Image(systemName: "clock")
                                .font(.system(size: 100))
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(secondsElapsed * 20))
                                .animation(.linear(duration: 0.01), value: secondsElapsed)
                            
                            Text("心の中で数えよう...")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        .padding(30)
                    }
                }
                
                Spacer()
                
                Group {
                    if isRunning {
                        Button {
                            stop()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "stop.fill")
                                    .font(.title3)
                                Text("ストップ")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .clipShape(Capsule())
                        }
                        .scaleEffect(isRunning ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isRunning)
                        
                    } else if showResult {
                        Button {
                            reset()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title3)
                                Text("もう一回")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .clipShape(Capsule())
                        }
                        
                    } else {
                        Button {
                            start()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                    .font(.title3)
                                Text("スタート")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }

    func start() {
        secondsElapsed = 0.0
        showResult = false
        resultScale = 1.0
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            secondsElapsed += 0.01
        }
    }

    func stop() {
        timer?.invalidate()
        isRunning = false
        let diff = abs(secondsElapsed - targetTime)
        let diffString = String(format: "%.2f", diff)

        if diff < 0.01 {
            resultMessage = "🎯 完璧！\nピッタリ！！"
            resultColor = .green
        } else if diff < 0.5 {
            resultMessage = "✨ 素晴らしい！\n誤差 \(diffString) 秒"
            resultColor = .green
        } else if diff < 1.0 {
            resultMessage = "👍 すごい！\n誤差 \(diffString) 秒"
            resultColor = .blue
        } else if diff < 3.0 {
            resultMessage = "😊 惜しい！\n誤差 \(diffString) 秒"
            resultColor = .orange
        } else {
            resultMessage = "😅 全然ダメ！\n誤差 \(diffString) 秒"
            resultColor = .red
        }

        showResult = true
    }

    func reset() {
        secondsElapsed = 0.0
        showResult = false
        resultScale = 1.0
        isRunning = false
    }
    
    func getResultIcon() -> String {
        let diff = abs(secondsElapsed - targetTime)
        if diff < 0.01 {
            return "crown.fill"
        } else if diff < 0.5 {
            return "star.fill"
        } else if diff < 1.0 {
            return "hand.thumbsup.fill"
        } else if diff < 3.0 {
            return "heart.fill"
        } else {
            return "arrow.clockwise"
        }
    }
}

#Preview {
    ContentView()
}
