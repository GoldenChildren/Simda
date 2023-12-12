# A709 금쪽이들의 SIMDA
## 프로젝트 개요
### 1. 진행기간
2023.07.03~2023.08.18 (7주)


 Simda 서비스는 이미지 캡셔닝과 구글 바드를 이용하여 개인이 업로드한 이미지와 텍스트에서 감정을 분석합니다. 사람의 여러 가지 감정 중 대표적인 행복, 신남, 평온, 화남, 슬픔 이 다섯 가지 감정을 꽃 모양으로 표현하여  사용자에게 알려줍니다. 이를 업로드 하는 순간 자신의 위치에 꽃모양으로 심어집니다. 피드 공간에서 팔로워한 친구들 뿐만 아니라 전체적으로 공유할 수 있는 위치 기반 감정 분석 SNS 입니다.

![img](/uploads/e5f1f09f57dee9581bd3b75f421d6e8b/img.gif)

### 2. 팀원 소개
<img src = "https://github.com/GoldenChildren/Simda/assets/122460802/259cd89a-9830-4c01-a9c5-4ae888cdc17b" width="450">

### 3. 폴더구조
ProjectSimda : Backend 폴더

TeamA709 : 스타트 캠프 자료

exec : 포팅 매뉴얼

frontend : Frontend 폴더 

## 프로젝트 소개
[![simdafigma](https://github.com/GoldenChildren/Simda/assets/122460802/de619e2a-7a0b-43d9-8fe0-07b2676c0c48)](https://www.figma.com/file/igLEfKOzK9Lbuq1UnitkYK/%EC%8B%AC%EB%8B%A4?type=design&node-id=0-1&mode=design)

### 1. 주요 기능 및 부가 기능
*주요기능
- 소셜로그인 기능. (카카오 & 구글)
- 이미지와 텍스트를 포함하는 글을 작성 및 삭제하는 기능. (업로드)
- 사용자가 올린 이미지와 텍스트에서 AI 가 감정을 분석.(이미지 캡셔닝 / 구글 바드)
- 구글 지도 API 를 이용하여 사용자의 위치에 감정을 심는 기능. (클러스터링 구현)
- 지도 화면 범위 내의 피드 모아보기 기능.
- Firebase 를 이용한 실시간 채팅기능.


*부가기능:
- 팔로잉/팔로워 기능.
- 피드 공감기능. (감정 꽃을 누를 수 있음)
- 피드 댓글 작성 및 삭제 기능.(대댓글 가능)
- 프로필 수정 기능. (사진 변경 및 닉네임 중복체크)
- 유저 검색 기능.
- 프로필 페이지. ( 내 감정을 달력에 표시하기, 내 피드 모아보기,  지도로 내감정 보기)



### 2. 기술 스택 
+ FrontEnd

+ BackEnd

### 3. 화면 구성
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/cd4a0061-6322-4f22-ba61-213d2b3d8942" width="200">  
<br>
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/e1e4e11a-5c70-4e0a-9d33-f1886a077b20" width="200">  
<br>
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/38f11258-c0be-476b-a8bc-685a5ee9aabc" width="200">  
<br>

메인 페이지/Home페이지/게시글 작성 페이지  
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/b5ceebda-5ce5-4015-8eef-d79fe0fcf0f6" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/2b7837b0-6767-4160-b8d5-73af7497999d" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/66c2be6b-871f-4019-a2cb-ea0687bb3bd5" width="200">  

AI 분석 페이지/피드 페이지/채팅 페이지  
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/da670623-fd60-4d46-866d-015a5f735acb" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/67e08a7f-091d-4f6c-8cea-88883f5cb22f" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/bff6f151-de08-476e-823c-659afd03c18d" width="200">  

프로필 달력 페이지/프로필 피드 페이지/프로필 지도 페이지  
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/6b767ee7-4b9b-4d0b-a1ab-df2257d79379" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/ac178608-6758-43e9-9697-2f2d88b7759b" width="200">
<img src="https://github.com/GoldenChildren/Simda/assets/90131462/a125be99-40fb-4d87-8b67-eb0ed986afb1" width="200">  



### 기타 링크
[PPT 발표 링크](https://www.canva.com/design/DAFrwICNf5A/kD4WbLgilbaFHOxD8VQ5-g/view?utm_content=DAFrwICNf5A&utm_campaign=designshare&utm_medium=link&utm_source=publishsharelink)

[유튜브 UCC 링크](https://www.youtube.com/watch?v=chIZHW4fDa0&feature=youtu.be)

[구글 스토어 링크](https://play.google.com/store/apps/details?id=com.ssafy.simda.simda)
