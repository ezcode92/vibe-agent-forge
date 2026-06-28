# Common Skill 가이드

## 목적

Common skill은 특정 language, framework, database 또는 platform과 무관하게 반복되는 agent 작업 절차를 재사용 가능한 단위로 제공한다. 모든 작업에 상시 적용되는 정책은 복제하지 않고, 특정 작업 유형에서만 필요한 순서, 판단과 완료 기준을 `SKILL.md`로 분리한다.

현재 공통 범위는 incremental implementation, debugging, test-first, code review, refactoring, API design review, security review와 git-auto 기반 commit worklog다.

## `AGENTS.md`와 Skill의 차이

| 구분 | `AGENTS.md` | Common skill |
| --- | --- | --- |
| 적용 시점 | 저장소 작업 전반에 항상 적용 | Description과 현재 작업이 일치하거나 명시 선택될 때 적용 |
| 책임 | 프로젝트 목적, 제약, 공통 보안·검증·Git 정책 | 특정 작업의 재현 가능한 절차, 분기와 완료 기준 |
| Context 비용 | 항상 읽히므로 짧게 유지 | Trigger된 작업에서만 본문을 읽음 |
| 권한 | 사용자·저장소 정책의 허용 범위 정의 | 기존 권한 안에서 수행 방식을 구체화 |

Skill은 상위 지침을 대체하거나 권한을 추가하지 않는다. `AGENTS.md`에는 어떤 상황에서 어떤 skill을 선택하는지에 필요한 짧은 진입 규칙만 둔다.

## Common Skill과 Stack-specific Skill의 차이

Common skill은 어떤 기술 조합에서도 의미가 유지되는 workflow를 제공한다. 예를 들어 debugging은 재현, 증거, 가설과 재검증 순서를 정의하지만 특정 runtime의 profiler나 framework transaction 진단법을 포함하지 않는다.

Stack-specific skill은 특정 생태계의 도구, lifecycle 또는 전문 검증이 없으면 수행할 수 없는 절차를 담당한다. 공통 흐름과 stack 절차가 모두 필요하면 common skill을 기본 workflow로 사용하고 stack-specific skill은 필요한 차이만 추가한다. 같은 절차를 양쪽에 복제하지 않는다.

## 필요할 때만 사용하는 이유

- 모든 skill 본문을 항상 로드하면 현재 작업과 무관한 절차가 context를 차지한다.
- 서로 다른 workflow의 단계와 완료 기준이 동시에 적용되어 책임과 우선순위가 불명확해질 수 있다.
- 간단한 작업에 복잡한 절차를 강제하면 불필요한 문서와 검증 비용이 생긴다.
- Metadata의 `name`과 `description`만으로 먼저 선택하고 필요한 skill 본문만 읽으면 작업 관련성과 재현성을 함께 유지할 수 있다.

Skill의 `description`에는 수행 목적과 trigger 조건을 포함한다. 본문은 선택 후 필요한 입력, 절차와 검증에 집중하고 상세한 stack 변형은 별도 skill 또는 reference로 분리한다.

## Profile Manifest 선택 기준

1. Profile이 반복적으로 수행할 작업 유형과 필수 품질 gate를 식별한다.
2. 모든 프로젝트에 상시 필요한 정책인지 조건부 workflow인지 구분한다.
3. 조건부 workflow이고 stack과 무관하면 registry의 common skill 식별자를 참조한다.
4. 특정 stack에서만 필요한 절차는 common skill 대신 stack-specific skill 또는 두 skill의 명시적 조합을 선택한다.
5. Skill 사이의 책임 중복, 순환 의존, 대상 agent 지원과 context 비용을 검토한다.

Profile은 skill 본문을 복제하지 않고 `skills`에 registry 식별자만 선언한다. 모든 common skill을 기본 포함하지 않으며 profile의 실제 작업과 검증 요구에 필요한 최소 집합만 선택한다.

## 작성 및 검증 기준

- 각 skill은 `name`, trigger를 포함한 `description`과 필수 8개 section을 가진다.
- 본문은 명령문 중심으로 간결하게 작성하고 하나의 작업 목적만 소유한다.
- 특정 stack의 command, annotation, library와 제품 동작을 포함하지 않는다.
- 실행하지 않은 검증을 성공으로 처리하지 않고 사용자·저장소 권한을 확장하지 않는다.
- Script, asset와 reference는 반복성과 필요성이 확인될 때만 추가하며 현재 common skill 초안에는 포함하지 않는다.

## 현재 범위

현재는 common `SKILL.md` 8종의 초안과 선택 기준만 정의한다. Stack-specific skill, 실제 profile YAML, skill catalog, agent별 metadata, 실행 script와 installer는 만들지 않는다.
