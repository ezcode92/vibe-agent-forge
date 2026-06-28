# Monolith Architecture Fragment

## 목적

하나의 배포 단위 안에서 단순한 실행·운영 모델과 명확한 내부 책임을 유지하는 원칙을 정의한다. 특정 언어, framework, database와 배포 제품은 다루지 않는다.

## 적용 대상

- Stack 식별자: `architecture-monolith`
- 적용 조건: 기능을 하나의 application 및 release 단위로 운영하는 시스템
- 제외 조건: 독립 배포와 network 격리가 핵심 요구인 service 구조

## 핵심 규칙

- Module boundary는 기능과 변경 이유를 기준으로 두되 배포 단위가 하나라는 사실보다 복잡한 격리를 만들지 않는다.
- Dependency direction을 명시하고 순환 의존과 모든 영역이 공유하는 범용 module을 방지한다.
- Data는 단일 배포 안에서도 책임 영역별 소유자를 정하고 다른 영역이 내부 representation을 직접 변경하지 않게 한다.
- In-process 호출의 단순성을 활용하고 필요하지 않은 network abstraction과 분산 실패 모델을 도입하지 않는다.
- Test는 내부 책임을 격리한 단위 검증과 전체 application 조합 검증을 구분한다.

## 권장 패턴

- 기능 경계를 package/module과 공개 API로 표현하고 내부 구현은 숨긴다.
- 공통 기능은 실제로 여러 경계가 공유하는 안정된 책임일 때만 분리한다.
- 단일 transaction과 직접 호출의 장점을 유지하면서 미래 분리보다 현재 변경 비용을 우선한다.

## 금지 패턴

- 단일 배포를 이유로 모든 component가 서로의 내부에 직접 접근하게 하지 않는다.
- 미래 service 분리를 가정한 remote facade, message 계층과 중복 model을 미리 만들지 않는다.
- 하나의 거대 module이나 shared package에 business 규칙을 집중시키지 않는다.
- 전체 application test만으로 모든 내부 동작을 검증하지 않는다.

## 검증 기준

- Module 책임, 공개 경계와 dependency direction을 설명할 수 있다.
- Data 변경 권한과 shared data의 소유자가 명확하다.
- 불필요한 분산 abstraction 없이 단일 배포 장점이 유지된다.
- 핵심 책임은 격리 test가 가능하고 전체 조합은 별도 test로 검증된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: Monolith boundary review skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- Framework module 구조나 database transaction을 이 경계에 연결할 때 조합 bridge가 필요하다.
- 내부 의존성 style을 Clean 또는 Hexagonal Architecture로 구체화할 때 profile/bridge에서 중복과 충돌을 검토한다.
