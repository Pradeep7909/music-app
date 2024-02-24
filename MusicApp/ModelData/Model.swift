//
//  Model.swift
//  MusicApp
//
//  Created by Qualwebs on 12/02/24.
//

import Foundation


struct User {
    var uid: String
    var email: String
    var name: String
    var credit : Int
    var purchasedSongs : [String]?
    var favoriteSongs : [String]?
}

struct Song: Identifiable , Decodable, Equatable{
    var id = UUID().uuidString
    var songId: String = ""
    var artistName: String
    var title: String
    var url: String
    var songImage : String
    var cost : Int
}


var allSongs: [Song] = [
    Song(artistName: "Badal", title: "Dream Girl", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FDream%20Girl%20-%20Badal.mp3?alt=media&token=d2c2fc94-b157-4bd4-9930-fbe0d48ca6e7", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fdreamgirl.png?alt=media&token=e8567803-7c1b-4e4b-80f3-dbc61074b753", cost: 10),
    Song(artistName: "Mohit Chauhan", title: "Tune Jo Na Kaha - LoFi Mix", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FTune%20Jo%20Na%20Kaha%20-%20LoFi%20Mix_.mp3?alt=media&token=886d490c-250d-4f0b-a352-5fadf2815d14", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FTuneJoNakaha.png?alt=media&token=bdcc7cd5-6dd1-4a8d-8770-5c9538d9da5b", cost: 10),
    Song(artistName: "Yo Yo Honey Singh", title: "Birthday Bash (Dilliwaali Zaalim Girlfriend)", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FBirthday%20Bash%20(Dilliwaali%20Zaalim%20Girlfriend).mp3?alt=media&token=cc2a02c8-2404-4e0d-a6c3-383edc1ed916", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FBirthdayBash.png?alt=media&token=d438b773-79f8-417d-9c68-3924e871f19e", cost: 10),
    Song(artistName: "Sonu Nigam, Alka Yagnik", title: "Neend Churayee Meri", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FNeend%20Churayee%20Meri.mp3?alt=media&token=5e4be478-996a-4d22-8bc0-b35d17cf9244", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fishq.png?alt=media&token=6def2bdc-f126-455e-a651-5bc674f8851d", cost: 15),
    Song(artistName: "Millind Gaba", title: "Kalesh", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FKalesh%20-%20Millind%20Gaba.mp3?alt=media&token=1f6dec58-22e9-40b6-bbf2-c0d99ece9e95", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fkalesh.png?alt=media&token=b293cc06-b3ce-4294-9e54-465160889270", cost: 12),
    Song(artistName: "Gurnazar Chattha", title: "Kali Kamli Wala Mera Yaar Hai", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FKali%20Kamli%20Wala%20Mera%20Yaar%20Hai.mp3?alt=media&token=549d61f5-7e28-413e-9ffc-67b15b805a54", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fkali_kamli.png?alt=media&token=8de2e797-ac14-49ff-8b34-30cde4fbde48", cost: 10),
    Song(artistName: "Yo Yo Honey Singh", title: "Call Aundi (Zorawar)", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FCall%20Aundi%20(Zorawar).mp3?alt=media&token=c8ffad73-a7f4-4b7a-b7f4-48a2ed657990", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FcallAundi.png?alt=media&token=252a1862-7e4e-4dad-838c-60e5d5ae4c77", cost: 10),
    Song(artistName: "Various Artists", title: "Mana Anjan Hai Tu Mere Vaste", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FMana%20Anjan%20Hai%20Tu%20Mere%20Vaste.mp3?alt=media&token=3c609441-c322-45e5-aa91-282f39ae5c26", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Ftaal.png?alt=media&token=cd336d7d-351d-46e8-843e-3c51d492cd75", cost: 10),
    Song(artistName: "Justin Bieber", title: "Baby", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FJustin%20Bieber%20-%20Baby.mp3?alt=media&token=2a3bcfc5-9851-45a1-bb20-596a28c46849", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fbaby.png?alt=media&token=b09ae687-a942-40a0-8fb4-07eab5b6210b", cost: 10),
    Song(artistName: "Gajendra Verma", title: "Mann Mera (Table No. 21)", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FMann%20Mera%20(Table%20No.%2021).mp3?alt=media&token=1be6ebc3-c97c-4155-b434-d488e5559368", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FmaanMera.png?alt=media&token=dd513c37-9a51-46f2-98f0-cd0828252672", cost: 10),
    Song(artistName: "Yo Yo Honey Singh", title: "Love Dose", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FLove%20Dose.mp3?alt=media&token=b8955cf6-ed9b-4ed6-acea-945e55d565c4", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FDesiKalakar.png?alt=media&token=44874628-5671-49c1-b6c0-0420ed36ab5b", cost: 10),
    Song(artistName: "Justin Bieber", title: "Let Me Love You", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FLet-Me-Love-You.mp3?alt=media&token=25e1b456-d6d4-4539-888b-e3a740e88b56", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Flet_me_love_U.png?alt=media&token=d2bebe84-dacd-4c30-bfd1-041895b26a8f", cost: 10),
    Song(artistName: "Luis Fonsi", title: "Despacito", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FLuis%20Fonsi%20-%20Despacito.mp3?alt=media&token=20fd1ca6-af20-4507-b54a-94e095b0abdd", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fdespacito.png?alt=media&token=e4770efe-ea56-4287-bf89-e26113d8769e", cost: 10),
    Song(artistName: "Millind Gaba", title: "Naam", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FNaam%20-%20Millind%20Gaba.mp3?alt=media&token=11c4f20c-ee88-4e79-bed1-0ca1816ac698", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fnaam.png?alt=media&token=241349ad-4bcc-465a-8078-66f444bd532e", cost: 10),
    Song(artistName: "Udit Narayan, Alka Yagnik", title: "Pata Nahi Kis Roop Mein Aakar", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FPata%20Nahi%20Kis%20Roop%20Mein%20Aakar.mp3?alt=media&token=d3fadf28-be41-41dd-ab12-f4da2f070ada", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fram.png?alt=media&token=e40e33d5-dca4-4a2a-bc93-efc616a07800", cost: 10),
    Song(artistName: "Guru Randhawa, Millind Gaba", title: "Yaar Mod Do", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FYaar%20Mod%20Do%20-%20Guru%20Randhawa,%20Millind%20Gaba.mp3?alt=media&token=b9d7f6d1-d0c3-47b0-b023-a27ea2e51a33", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FYaarModDo.png?alt=media&token=f71671d3-c6a5-4782-9cfa-28069722692a", cost: 10),
    Song(artistName: "Jasmine Sandlas, Yo Yo Honey Singh", title: "Raat Jashan Di", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FRaat%20Jashan%20Di%20(Zorawar).mp3?alt=media&token=7cc6ccec-a34e-4576-b8ad-ce8abfe55a68", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2FraatJasanDi.png?alt=media&token=339c175e-d283-479a-bcab-9e74a8acf248", cost: 10),
    Song(artistName: "Udit Narayan, Alka Yagnik", title: "Pardesi Pardesi Jaana Nahin", url: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songs%2FPardesi%20Pardesi%20Jaana%20Nahin.mp3?alt=media&token=0d9b4c7b-9e5c-4812-80a1-7dc9a16645d5", songImage: "https://firebasestorage.googleapis.com:443/v0/b/music-app-04.appspot.com/o/songImages%2Fpardesi.png?alt=media&token=0b42ef1e-4436-4bbd-a8d5-10bbdc5a5c4b", cost: 10)
]



var allUpdatedSongs: [Song] = [
    Song(artistName: "Yo Yo Honey Singh", title: "Call Aundi (Zorawar)", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FCall%20Aundi%20(Zorawar)_64-(PagalWorld.Ink).mp3?alt=media&token=f72d2f44-defd-4b61-b52d-5a80756ee3c5", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FcallAundi.png?alt=media&token=576b4f08-38e9-42ff-bf46-b73aa5f94219", cost: 10),
    Song(artistName: "Yo Yo Honey Singh", title: "Birthday Bash (Dilliwaali Zaalim Girlfriend)", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FBirthday%20Bash%20(Dilliwaali%20Zaalim%20Girlfriend)_64-(PagalWorld.Ink).mp3?alt=media&token=fa9d6f62-1c1f-4ce1-b65d-d1f5afe73ffe", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FbirthdayBash.png?alt=media&token=5c944c8a-8140-4842-bfc9-69b7156ab6c7", cost: 10),
    Song(artistName: "Justin Bieber", title: "Baby", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FJustin%20Bieber%20-%20Baby_64-(PagalWorld.Ink).mp3?alt=media&token=11090c98-42ae-4ed8-9241-fc653d690ed7", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2Fbaby.png?alt=media&token=4c49ebc6-8afd-4a48-a7e7-fd061ac2d261", cost: 10),
    Song(artistName: "Millind Gaba", title: "Naam", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FNaam%20-%20Millind%20Gaba_64-(PagalWorld.Ink).mp3?alt=media&token=d5afc0d4-2b7d-41c2-b7df-7d440c597759", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FNaam.png?alt=media&token=3cc15b98-6505-4d5f-b416-c9916cbd2b44", cost: 10),
    Song(artistName: "Luis Fonsi", title: "Despacito", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FLuis%20Fonsi%20-%20Despacito_64-(PagalWorld.Ink).mp3?alt=media&token=a0f78995-e39b-4a26-819f-d6ec4029a333", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2Fdespacito.png?alt=media&token=44862a57-b27c-4a43-a409-12c75e7c90bc", cost: 10),
    Song(artistName: "Badal", title: "Dream Girl", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FDream%20Girl%20-%20Badal_64-(PagalWorld.Ink).mp3?alt=media&token=9e2d55c1-590e-4a5f-955f-00ae346549b5", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2Fdreamgirl.png?alt=media&token=3f34c0ad-823d-4e79-9555-22a5909a006c", cost: 10),
    Song(artistName: "Various Artists", title: "Mana Anjan Hai Tu Mere Vaste", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FMana%20Anjan%20Hai%20Tu%20Mere%20Vaste_64-(PagalWorld.Ink).mp3?alt=media&token=76506c2f-c99b-44c3-accc-455d795a7a01", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FmanaAnjanHai.png?alt=media&token=b9339ad4-45a1-4abb-9d21-0bbebb1c59de", cost: 10),
    Song(artistName: "Yo Yo Honey Singh", title: "Love Dose", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FLove%20Dose_64-(PagalWorld.Ink).mp3?alt=media&token=9f9427c0-e5b1-49e1-9da2-fbf72bae50f3", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FloveDose.png?alt=media&token=21c53f6d-72f9-4100-aa62-4d5fec8868c5", cost: 10),
    Song(artistName: "Mohit Chauhan", title: "Tune Jo Na Kaha - LoFi Mix", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FTune%20Jo%20Na%20Kaha%20-%20LoFi%20Mix_64-(PagalWorld.Ink).mp3?alt=media&token=7a44637d-cead-4bac-81a9-3241116388cc", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FtuneJoNaKaha.png?alt=media&token=f9b0ed03-77da-4e9e-948f-a0b6ae5ae11a", cost: 10),
    Song(artistName: "Gajendra Verma", title: "Mann Mera (Table No. 21)", url: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songAudio%2FMann%20Mera%20(Table%20No.%2021)_64-(PagalWorld.Ink).mp3?alt=media&token=2e4bd3d7-ba77-414c-bcfa-91cb92acc833", songImage: "https://firebasestorage.googleapis.com:443/v0/b/my-music-c7688.appspot.com/o/songImages%2FManMera.png?alt=media&token=596a4ecb-c83f-4487-9312-31d69a860a29", cost: 10)
]



var staticSongs = [
    Song(songId: "demoSong1", artistName: "Max Beats", title: "Groovy Vibes", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", songImage: "https://jooinn.com/images/multicolored-music-background-shows-song-randb-or-blues.jpg", cost: 10),
    Song(songId: "demoSong2", artistName: "Melody Masters", title: "Smooth Melodies", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", songImage: "https://img.freepik.com/free-vector/music-background-with-musical-notes_1302-13613.jpg?size=626&ext=jpg", cost: 10),
]
