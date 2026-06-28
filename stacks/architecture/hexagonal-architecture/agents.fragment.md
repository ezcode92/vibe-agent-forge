# Hexagonal Architecture Fragment

## 목적

Application core를 port로 정의하고 외부 actor와 기술을 adapter로 격리하는 architecture 원칙을 정의한다. 배포 형태, 특정 framework, language, protocol과 저장 제품은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-hexagonal-architecture`
- 적용 조건: 여러 입력·출력 기술에서 application 동작을 보호하고 adapter를 독립 교체·검증할 필요가 있는 시스템
- 제외 조건: 실제 외부 경계가 없거나 port 추가가 단순 동작보다 더 큰 간접성을 만드는 경우

## 핵심 규칙

- Module boundary는 application core, inbound port, outbound port와 adapter의 책임으로 구분한다.
- Dependency는 adapter에서 port와 core 방향으로 향하고 core는 adapter 구현과 외부 기술 type을 알지 않는다.
- Inbound port는 actor가 요청하는 use case를, outbound port는 core가 외부에 요구하는 capability를 표현한다.
- Data ownership과 invariant는 core에 두고 adapter model은 경계에서 변환한다.
- Core test는 port를 통해 외부 dependency 없이 실행하고 adapter는 해당 port contract 및 실제 기술 경계를 별도로 검증한다.

## 권장 패턴

- Port는 기술 이름보다 business 목적과 호출자가 필요한 최소 operation으로 설계한다.
- 하나의 port에 여러 adapter가 있을 때 의미, 오류와 transaction 기대가 동일한지 확인한다.
- Adapter는 변환, protocol 또는 persistence 연동에 집중하고 business 판단을 복제하지 않는다.

## 금지 패턴

- 모든 class에 interface를 만들거나 외부 경계가 아닌 내부 호출까지 port로 포장하지 않는다.
- Port가 framework type, wire model 또는 storage query 세부사항을 노출하지 않는다.
- Adapter마다 business rule과 오류 의미를 다르게 구현하지 않는다.
- Core test가 실제 network, database 또는 framework container를 필수로 요구하게 하지 않는다.

## 검증 기준

- 각 port의 actor, 목적, 방향과 소유자가 명확하다.
- Core dependency가 adapter 또는 외부 기술로 향하지 않는다.
- Data 변환과 오류 mapping이 adapter 경계에 있고 invariant는 core에서 보호된다.
- Core, port contract와 adapter integration test가 책임별로 분리된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Port/adapter boundary 또는 dependency review skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Framework, API 또는 database 구현을 구체 adapter로 연결할 때 해당 stack bridge가 필요하다.
- Monolith 또는 MSA 배포 경계와 조합할 때 port와 module/service 경계의 소유권을 profile/bridge에서 정리한다.
