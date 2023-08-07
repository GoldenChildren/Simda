import 'package:flutter/material.dart';

class InformationPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("개인정보 처리 방침", style: TextStyle(color: Colors.grey),),
        leading:  IconButton(
            onPressed: () {
              Navigator.pop(context); //뒤로가기
            },
            color: Colors.grey,
            icon: const Icon(Icons.arrow_back)),
    ),
    body: Center(

      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // adding borders around the widget

        ),
        // SingleChildScrollView should be
        // wrapped in an Expanded Widget
        child: const Expanded(
          //contains a single child which is scrollable
          child: SingleChildScrollView(
            //for horizontal scrolling
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
              child: Text("*< 금쪽이들 >('안드로이드 애플리케이션'이하 '심다')*은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.\n○ 이 개인정보처리방침은 *2023*년 *7*월 *18*부터 적용됩니다.\n**제1조(개인정보의 처리 목적)\n< 금쪽이들 >('안드로이드 애플리케이션'이하 '심다')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.**\n1. 홈페이지 회원가입 및 관리\n회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 만14세 미만 아동의 개인정보 처리 시 법정대리인의 동의여부 확인 목적으로 개인정보를 처리합니다.\n**제2조(개인정보의 처리 및 보유 기간)**\n① < 금쪽이들 >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.\n② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n1.<홈페이지 회원가입 및 관리><홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<지체없이 파기>까지 위 이용목적을 위하여 보유.이용됩니다.보유근거 : 탈퇴 시 1개월 동안 사용자 정보 유지 후 파기\n관련법령 :\n예외사유 :\n**제3조(처리하는 개인정보의 항목)**\n① < 금쪽이들 >은(는) 다음의 개인정보 항목을 처리하고 있습니다.\n1< 홈페이지 회원가입 및 관리 >\n필수항목 : 로그인ID, 이메일\n선택항목 :\n**제4조(만 14세 미만 아동의 개인정보 처리에 관한 사항)**\n① <개인정보처리자명>은(는) 만 14세 미만 아동에 대해 개인정보를 수집할 때 법정대리인의 동의를 얻어 해당 서비스 수행에 필요한 최소한의 개인정보를 수집합니다.\n• 필수항목 : 법정 대리인의 성명, 관계, 연락처\n② 또한, <개인정보처리자명>의 <처리목적> 관련 홍보를 위해 아동의 개인정보를 수집할 경우에는 법정대리인으로부터 별도의 동의를 얻습니다.\n③ <개인정보처리자명>은(는) 만 1 4세 미만 아동의 개인정보를 수집할 때에는 아동에게 법정대리인의 성명, 연락처와 같이 최소한의 정보를 요구할 수 있으며, 다음 중 하나의 방법으로 적법한 법정대리인이 동의하였는지를 확인합니다.\n• 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 개인정보처리자가 그 동의 표시를 확인했음을 법정대리인의 휴대전화 문자 메시지로 알리는 방법\n• 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 법정대리인의 신용카드·직불카드 등의 카드정보를 제공받는 방법\n• 동의 내용을 게재한 인터넷 사이트에 법정대리인이 동의 여부를 표시하도록 하고 법정대리인의 휴대전화 본인인증 등을 통해 본인 여부를 확인하는 방법\n• 동의 내용이 적힌 서면을 법정대리인에게 직접 발급하거나, 우편 또는 팩스를 통하여 전달하고 법정대리인이 동의 내용에 대하여 서명날인 후 제출하도록 하는 방법\n• 동의 내용이 적힌 전자우편을 발송하여 법정대리인으로부터 동의의 의사표시가 적힌 전자우편을 전송받는 방법\n• 전화를 통하여 동의 내용을 법정대리인에게 알리고 동의를 얻거나 인터넷주소 등 동의 내용을 확인할 수 있는 방법을 안내하고 재차 전화 통화를 통하여 동의를 얻는 방법\n• 그 밖에 위와 준하는 방법으로 법정대리인에게 동의 내용을 알리고 동의의 의사표시를 확인하는 방법\n**제5조(개인정보의 제3자 제공에 관한 사항)**\n① < 금쪽이들 >은(는) 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.\n② < 금쪽이들 >은(는) 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.\n1. < 금쪽이들 >\n개인정보를 제공받는 자 : 금쪽이들\n제공받는 자의 개인정보 이용목적 : 로그인ID, 이메일\n제공받는 자의 보유.이용기간: 지체없이 파기\n**제6조(개인정보처리의 위탁에 관한 사항)**\n① < 금쪽이들 >은(는) 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.\n1. < >위탁받는 자 (수탁자) : 없음\n위탁하는 업무의 내용 : 없음\n위탁기간 : 없음\n② < 금쪽이들 >은(는) 위탁계약 체결시 「개인정보 보호법」 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적․관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리․감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.\n③ 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.\n**제7조(개인정보의 파기절차 및 파기방법)**\n① < 금쪽이들 > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.\n1. 법령 근거 :\n2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜\n③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.1. 파기절차< 금쪽이들 > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < 금쪽이들 > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.\n2. 파기방법\n전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다\n**제8조(미이용자의 개인정보 파기 등에 관한 조치)**\n① <개인정보처리자명>은(는) 1년간 서비스를 이용하지 않은 이용자는 휴면계정으로 전환하고, 개인정보를 별도로 분리하여 보관합니다. 분리 보관된 개인정보는 1년간 보관 후 지체없이 파기합니다.\n② <개인정보처리자명>은(는) 휴먼전환 30일 전까지 휴면예정 회원에게 별도 분리 보관되는 사실 및 휴면 예정일, 별도 분리 보관하는 개인정보 항목을 이메일, 문자 등 이용자에게 통지 가능한 방법으로 알리고 있습니다.\n③ 휴면계정으로 전환을 원하지 않으시는 경우, 휴면계정 전환 전 서비스 로그인을 하시면 됩니다. 또한, 휴면계정으로 전환되었더라도 로그인을 하는 경우 이용자의 동의에 따라 휴면계정을 복원하여 정상적인 서비스를 이용할 수 있습니다.\n**제9조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)**\n① 정보주체는 금쪽이들에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.\n② 제1항에 따른 권리 행사는금쪽이들에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 금쪽이들은(는) 이에 대해 지체 없이 조치하겠습니다.\n③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.\n④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.\n⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.\n⑥ 금쪽이들은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.\n**제10조(개인정보의 안전성 확보조치에 관한 사항)\n< 금쪽이들 >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.**\n1. 개인정보에 대한 접근 제한개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.\n2. 개인정보의 암호화이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.\n**제11조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)**\n금쪽이들 은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용하지 않습니다.\n**제12조 (개인정보 보호책임자에 관한 사항)**\n① 금쪽이들 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n▶ 개인정보 보호책임자\n성명 :전현태\n연락처 :01094167342, jht043@naver.com\n② 정보주체께서는 금쪽이들 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 금쪽이들 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.\n제13조(개인정보의 열람청구를 접수·처리하는 부서)정보주체는 ｢개인정보 보호법｣ 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다.< 금쪽이들 >은(는) 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.\n▶ 개인정보 열람청구 접수·처리 부서\n담당자 : 전현태\n연락처 : 01094167342, jht043@naver.com\n**제14조(정보주체의 권익침해에 대한 구제방법)**\n정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.\n1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)\n「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.\n**제15조(개인정보 처리방침 변경)**\n① 이 개인정보처리방침은 2023년 7월 18부터 적용됩니다."),
            ),
          ),
        ),
      ),
    ),
    );
  }
}