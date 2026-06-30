# Bridge Fragment 가이드

## 목적

Bridge fragment는 둘 이상의 stack이 함께 선택될 때만 발생하는 type mapping, lifecycle, transaction, 계약과 책임 연결 규칙을 관리한다. 독립 stack fragment가 다른 기술을 전제하지 않게 하면서 실제 조합의 위험과 검증 기준을 명시하는 것이 목적이다.

Bridge는 새로운 stack의 일반 규칙을 정의하지 않는다. 구성 요소 사이의 경계에서만 유효한 차이를 추가하며 필수 stack 중 하나라도 빠지면 적용하지 않는다.

## 단일 Stack Fragment와의 차이

| 구분 | 단일 stack fragment | Bridge fragment |
| --- | --- | --- |
| 적용 조건 | 해당 stack 하나를 선택하면 적용 | 선언된 stack 조합이 모두 선택될 때 적용 |
| 책임 | 기술 자체의 관례와 검증 | 기술 사이의 mapping, lifecycle과 계약 연결 |
| 변경 이유 | 단일 기술의 지원 방식 변경 | 조합의 상호작용 또는 호환성 변경 |
| 예시 | Language nullability, framework lifecycle, API contract | Nullability와 config binding 연결, client/server error schema 공유 |

같은 규칙이 한 stack만으로도 완전하게 설명되면 bridge가 아니라 해당 stack fragment에 둔다.

## Bridge Fragment가 필요한 조건

- 둘 이상의 stack이 동시에 존재할 때만 규칙이 유효하다.
- 한쪽의 type, 오류 또는 lifecycle을 다른 쪽 의미로 변환해야 한다.
- Transaction, 비동기 context, resource ownership이 기술 경계를 통과한다.
- Client와 server 또는 framework와 database가 versioned contract를 공유한다.
- 단일 fragment에 규칙을 넣으면 선택하지 않은 기술까지 불필요하게 전제한다.

단순히 두 stack이 profile에 함께 있다는 이유만으로 bridge를 추가하지 않는다. 실제 상호작용과 독립 fragment로 해결할 수 없는 검증 책임이 있어야 한다.

## Bridge Fragment에 넣지 않는 내용

- 한 language, framework, database 또는 API에만 적용되는 일반 관례
- 특정 제품의 설정 key, query 문법, annotation 조합과 설치 절차
- Project별 endpoint, schema, credential, 환경값과 실제 명령
- 구현 code, generator, adapter, migration script와 배포 자동화
- 조건부 debugging이나 운영 대응의 긴 workflow
- 선택된 stack과 무관한 core 품질 및 Git 작업 원칙

제품 capability가 필요한 규칙은 product-specific fragment나 별도 bridge로 분리한다. 반복 작업 절차는 skill에 두고 bridge에는 언제 어떤 경계를 검증할지만 남긴다.

## Profile Manifest에서의 선택 기준

1. Profile의 `stacks`에 필요한 독립 stack을 먼저 선언한다.
2. 선택된 stack 사이에 실제 type, lifecycle, data 또는 protocol 연결이 있는지 확인한다.
3. 해당 조합을 지원하는 bridge가 registry에 있고 상태 및 대상 agent가 호환되는지 확인한다.
4. Bridge가 선언한 필수 stack이 모두 선택되었는지, 다른 bridge와 책임이 겹치거나 충돌하지 않는지 검증한다.
5. 필요한 bridge 식별자만 profile의 `bridges`에 명시하고 본문을 profile에 복제하지 않는다.

필수 bridge가 없거나 지원 상태가 불명확하면 조합을 암묵적으로 허용하지 않고 미지원 또는 추가 설계 필요로 진단한다. Optional bridge는 적용하지 않았을 때의 기능 제한이 명확한 경우에만 선택 사항으로 둔다.

## Merge Priority와 충돌 처리

Bridge fragment는 `docs/merge-policy.md`에 따라 core, language, architecture/database/API, framework/platform fragment보다 높은 우선순위로 병합되고 profile override와 project·사용자 지침보다 낮다.

높은 우선순위는 독립 fragment의 일반 규칙을 임의로 삭제하는 권한이 아니다. 같은 의미 영역에서 조합 조건이 더 구체적인 경우에만 규칙을 보완하거나 대체하고 출처와 이유를 진단에 남긴다. 두 bridge가 같은 조건에서 반대 동작, 서로 다른 소유자 또는 양립할 수 없는 lifecycle을 요구하면 임의 선택하지 않고 생성 실패로 처리한다.

## 검증 기준

- 각 bridge가 필수 stack과 비적용 조건을 명시한다.
- 핵심 규칙마다 두 stack 이상의 상호작용이 확인된다.
- 단일 stack 일반 규칙, 제품 설정과 구현 절차가 반복되지 않는다.
- Profile 선택 시 필수 stack, 의존 bridge, 충돌과 지원 상태를 검증할 수 있다.
- Merge 결과가 더 구체적인 조합 규칙만 추가하고 상위 project·사용자 지침을 약화하지 않는다.

## 현재 범위

현재 Spring–Modular Monolith를 포함한 bridge fragment 8개가 존재하며 registry와 profile에서 조합 관계를 참조한다. 이 문서는 적용·병합 기준을 정의하며 bridge 실행 코드, generator와 installer는 구현하지 않는다.
