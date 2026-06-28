# Clean Architecture Fragment

## 목적

Use case와 business policy를 중심에 두고 외부 기술 세부사항을 바깥 경계로 격리하는 의존성 원칙을 정의한다. 배포 형태, 특정 framework, language와 저장 기술은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-clean-architecture`
- 적용 조건: Business rule의 장기 안정성과 외부 기술 교체·격리 가치가 추가 경계 비용보다 큰 시스템
- 제외 조건: 단순 CRUD나 작은 범위에서 계층 분리가 문제보다 더 큰 복잡성을 만드는 경우

## 핵심 규칙

- Module/layer boundary는 entity/business rule, use case, interface adapter와 외부 detail의 책임 차이로 구분한다.
- Source dependency는 바깥 detail에서 안쪽 policy 방향으로만 향하고 안쪽은 framework, transport와 storage type을 알지 않는다.
- Data ownership은 business invariant를 보호하는 안쪽 경계에 두며 외부 표현을 내부 model로 직접 사용하지 않는다.
- Use case는 입력, 결과와 실패를 명시하고 UI, database 또는 delivery mechanism 없이 검증 가능해야 한다.
- Boundary model은 경계별 필요에 맞게 두되 의미 차이가 없는 복제와 mapping 계층은 만들지 않는다.

## 권장 패턴

- 외부 dependency가 필요한 use case에는 최소한의 목적 지향 interface를 안쪽에 정의한다.
- Framework object는 adapter에서 변환하고 business rule로 누출하지 않는다.
- 경계별 test는 business policy, use case 조정과 외부 adapter 계약을 독립적으로 검증한다.

## 금지 패턴

- 모든 기능에 동일한 수의 layer, interface와 mapping을 기계적으로 만들지 않는다.
- Domain 또는 use case가 framework annotation, transport request나 persistence entity에 의존하게 하지 않는다.
- 단순 전달만 하는 계층을 architecture 준수 목적으로 추가하지 않는다.
- 내부 model을 외부 계약과 database schema의 동시 표현으로 사용하지 않는다.

## 검증 기준

- 각 경계의 변경 이유와 dependency direction을 설명할 수 있다.
- Business rule과 use case가 외부 기술 없이 test 가능하다.
- Data 변환 위치와 내부 model 소유권이 명확하다.
- 추가된 interface와 layer마다 실제 격리 또는 변화 축 근거가 있다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Dependency direction 또는 use case boundary review skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Framework component를 outer adapter에 배치하거나 database/API model을 boundary model에 연결할 때 bridge가 필요하다.
- Monolith 또는 MSA 같은 배포 형태와 조합할 때 module/service 경계 중복을 profile/bridge에서 검토한다.
