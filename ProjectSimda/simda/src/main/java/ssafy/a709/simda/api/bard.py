import sys
import os
import io
import bardapi

sys.stdout = io.TextIOWrapper(sys.stdout.detach(), encoding="utf-8")
sys.stderr = io.TextIOWrapper(sys.stderr.detach(), encoding="utf-8")

workingdirectory = os.getcwd()

def addition():
    os.environ['_BARD_API_KEY']="Ygj5yW4U7eHBq5WAD5CPYQlzJ-Bi0nrNSdAkri99eP1VIqXc4gzGainsORoV0sgLpsolPw."
    
# 질문 작성

    input_text = sys.argv[1]
    # input_text = "존나 빡치네"
    
    input_tailInfo = "(이)라는 문장은 다음 보기 중 어디에 가장 가까워? 0 : 행복, 1 : 기쁨, 2 : 평온, 3 : 화남, 4 : 슬픔. 대답은 다음과 같은 형식으로만 대답해. ex) 답 : 1"
    
    # 영어 버전
    # input_text = sys.argv[1] + "Which of the following examples is the closest to the sentence (this)? Number 1: Happiness, Number 2: Calm, Number 3: Joy, Number 4: Sad, Number 5: Angry. Answer only in the following format. Example: Number 1"
    input_text += input_tailInfo

    response = bardapi.core.Bard().get_answer(input_text)
    # print(input_text)
    print(response['content'])

addition()