//
//  QuizView.swift
//  OneSecond
//
//  Created by Doran on 6/18/24.
//

import SwiftUI
import MusicKit

struct QuizView: View {
    
    @StateObject private var musicManager = MusicManager.shared
    @State var hintCount: Int = 3
    @State var isCorrect: Bool = false
    @State var currentQuestionCount: Int = 1
    let questionCount: Int
    let playTime: Int
    
    
    var body: some View {
        VStack{
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(hex: "787880"))
                    .opacity(0.16)
                    .frame(width:UIScreen.main.bounds.width - 32,height: 8.0)
                    .cornerRadius(4.0)
                Rectangle()
                    .foregroundColor(Color(hex: "FF0080"))
                    .frame(width: (Double(currentQuestionCount) / Double(questionCount)) * (UIScreen.main.bounds.width - 32), height: 8.0)
                    .cornerRadius(4.0)
                    .animation(.easeInOut, value: currentQuestionCount)
            }
            HStack{
                Spacer()
                Text("\(currentQuestionCount)/\(questionCount)").font(.system(size: 12, weight: .semibold))
            }
            Spacer()
            
            Text("여러분의 음악 감각을\n보여주세요!").font(.system(size: 24, weight: .bold))
                .padding(.top,6)
                .multilineTextAlignment(.center)

                
            
            ZStack{
                if let artwork = musicManager.song?.artwork {
                    ArtworkImage(artwork,width: 260, height: 260).cornerRadius(50).shadow(color: .gray, radius: 1, x: 0, y: 2)
                    Image("DefaultImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260, height: 260)
                        .cornerRadius(50)
                        .opacity(hintCount > 2 ? 1 : 0)
                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
                }
//                if(hintCount > 2){
//                    Image("DefaultImage")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 260, height: 260)
//                        .cornerRadius(50)
//                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
//                }
            }
            .padding(.top,14)

            if let title = musicManager.song?.title {
                Text(title).font(.system(size: 24, weight: .bold)).padding(.top,10).opacity(isCorrect ? 1 : 0)
                    .padding(.bottom,1)
                    .multilineTextAlignment(.center)

            }
            
            if let artistName = musicManager.song?.artistName {
                Text(artistName).font(.system(size: 17, weight: .semibold)).opacity(hintCount<2 ? 1 : 0)
            }
            
            if let releaseDate = musicManager.song?.releaseDate {
                let dateString = dateToString(releaseDate)
                Text(dateString).font(.system(size: 10, weight: .semibold)).opacity(hintCount < 1 ? 1 : 0)
            }
           
            Button(action:{
                print(hintCount)
                if let randomSong = musicManager.song {
                    if(hintCount < 0){
                        musicManager.playSongPlay(randomSong)
                    }
                    else{
                        if(playTime == 0){
                            musicManager.playSongPlay(randomSong)
                        }
                        else{
                            musicManager.songPlayForTime(randomSong, time: Double(playTime))
                        }
                    }
                }
            }){
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(hex: "#000000"))
                
            }
            .padding(.top,14)
            .padding(.leading,1.1)
            
            Button(action:{
                withAnimation{
                    hintCount-=1
                }
                print(hintCount)
                
                if (hintCount < 0){
                    withAnimation{
                        isCorrect = true
                    }
                }
                
                if(hintCount < -1){
                    print("다음문제로 넘어갑니다.")
                    hintCount = 3
                    isCorrect = false
                    
                    if(currentQuestionCount == questionCount){
                        NavigationManager.shared.push(to: .quizFinish)
                    }
                    else{
                        musicManager.getRandomTrack(time: Double(playTime))
                        currentQuestionCount+=1
                        print(currentQuestionCount)
                    }
                }
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 40).frame(width: 130,height: 50).foregroundColor(Color(hex: "#000000"))
                    Text(hintCount < 1 ?
                         hintCount < 0 ?
                         "다음 문제":"정답 보기" : "힌트 \(hintCount)/3").font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                }
            }.padding(.top,10)
            
            Button(action:{
                withAnimation{
                    hintCount = -1
                    isCorrect = true
                }
            }){
                Text("정답 바로보기").font(.system(size: 12, weight: .regular)).foregroundColor(.black).opacity(hintCount > 0 ? 1 : 0)
            }.disabled(hintCount <= 0)
            .padding(.top, 40)
        }
        .padding(.horizontal,16)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    NavigationManager.shared.pop(to: .selectYear)
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(.black)
                        .padding(.vertical, 11)
                        .padding(.top,5)
                        .padding(.bottom,5)
                }
                .frame(width: 44, height: 44)
            }
        }
        .padding(.top,20)
        .onAppear{
            musicManager.getRandomTrack(time: Double(playTime))
        }
        .onDisappear{
            musicManager.musicPlayer.pause()
        }
    }
}

extension QuizView{
    func dateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}


#Preview {
    QuizView(questionCount: 10, playTime: 1)
}
