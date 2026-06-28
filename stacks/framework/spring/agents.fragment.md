# Spring Framework Fragment

## 목적

Spring의 application component, container configuration, transaction, validation, 예외 처리와 test context에 공통으로 적용할 framework 수준의 판단 기준을 정의한다. 기반 언어의 문법·타입 관례, database 모델과 architecture topology는 다루지 않는다.

## 적용 대상

- Stack 식별자: `framework-spring`
- 적용 조건: Spring container와 application framework 기능을 사용하는 프로젝트
- 제외 조건: 기반 언어만 사용하는 module 또는 특정 database·전송 계약의 세부 설계

## 핵심 규칙

- 외부 요청 해석, use case 조정, domain 판단과 외부 resource 접근의 책임을 구분하고 한 component가 여러 경계의 세부사항을 동시에 소유하지 않게 한다.
- Bean은 container가 관리해야 하는 application 책임과 lifecycle이 있을 때만 등록한다. 단순 데이터 객체나 지역 helper를 관성적으로 bean으로 만들지 않는다.
- Configuration은 기능 단위로 응집시키고 bean 생성 조건, property와 override 관계를 명시한다. Component scan과 자동 설정에 기대어 소유권을 숨기지 않는다.
- Transaction boundary는 하나의 일관된 application operation을 기준으로 service 경계에 둔다. 경계를 불필요하게 넓히거나 외부 통신과 장시간 작업을 transaction 안에 묶지 않는다.
- 입력 형식 검증과 business invariant 검증을 구분하고, 검증 시점과 실패 책임을 해당 경계에 둔다.
- Exception은 가장 가까운 복구 가능 경계에서 처리한다. Framework 전역 처리기는 내부 원인을 숨기지 않으면서 외부 계약에 필요한 일관된 실패 표현으로 변환한다.
- Test는 확인하려는 책임에 맞는 slice를 선택하고, container 전체를 띄우는 test는 component 조합과 설정 통합을 검증할 때로 제한한다.

## 권장 패턴

- Constructor 기반 dependency 전달로 필수 협력 관계를 명시하고 test에서 경계를 대체할 수 있게 한다.
- Controller 또는 transport adapter는 입력 변환과 응답 위임에 집중하고 application 판단을 직접 구현하지 않는다.
- Configuration property는 의미 있는 단위로 묶고 시작 시점에 필수 값과 범위를 검증한다.
- Transaction 적용 위치는 proxy 경계, 호출 방향과 rollback 조건을 함께 검토한다.
- Slice test는 대상 외 dependency를 명시적으로 대체하고, 전체 context test와 중복되는 검증을 만들지 않는다.

## 금지 패턴

- 모든 책임을 controller, service 또는 단일 manager에 집중시키지 않는다.
- Field injection, service locator 방식 또는 application context 직접 조회로 dependency를 숨기지 않는다.
- 편의를 위해 모든 public method나 전체 class에 transaction을 일괄 적용하지 않는다.
- Validation annotation만으로 business invariant가 보장된다고 가정하지 않는다.
- 모든 exception을 하나의 성공 또는 일반 오류 형태로 바꾸거나 원인·분류를 잃지 않는다.
- 작은 책임 검증을 위해 매번 전체 application context와 외부 resource를 시작하지 않는다.

## 검증 기준

- 각 Spring component의 경계, dependency와 container 관리 이유를 설명할 수 있다.
- Configuration과 property의 소유권, 조건 및 실패 시점이 명확하다.
- Transaction의 시작·종료, rollback 조건과 외부 작업 포함 여부가 검토되었다.
- 입력 검증과 business 검증의 책임 및 exception 변환 경계가 구분된다.
- Test 범위가 대상 책임과 일치하고 slice, 통합 test 사이의 중복과 누락이 없다.
- 프로젝트가 선언한 Spring test, 설정 검사와 build가 통과하거나 미실행 사유가 보고된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Spring transaction, configuration 또는 test 진단 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- 기반 언어의 타입·비동기 모델을 Spring lifecycle에 연결할 때 language–Spring bridge가 필요하다.
- Transaction을 특정 persistence 기술과 연결하거나 transport 오류 계약을 확정할 때 database/API bridge가 필요하다.
- 해당 조합의 세부 규칙은 이 fragment에 추가하지 않는다.
