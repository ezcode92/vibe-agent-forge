# Skill 설계 명세

## Skill의 역할

Skill은 특정 작업 조건에서 선택적으로 불러오는 전문 절차다. 반복 가능한 작업 순서, 판단 기준, 검증 방법과 완료 조건을 한 단위로 관리해 `AGENTS.md`를 짧게 유지한다.

Skill은 에이전트에게 새로운 권한을 주지 않는다. 사용자 요청과 전역·프로젝트 지침이 허용한 범위 안에서만 절차를 구체화한다.

## Skill과 `AGENTS.md`의 차이

| 구분 | `AGENTS.md` | Skill |
| --- | --- | --- |
| 적용 시점 | 저장소 작업 전반에 항상 적용 | 사용 조건이 충족되거나 명시적으로 호출될 때 적용 |
| 내용 | 목적, 제약, 공통 작업 원칙, skill 선택 기준 | 특정 작업의 절차, 분기, 검증과 완료 기준 |
| 길이 | 짧고 지속적으로 필요한 규칙 중심 | 필요한 만큼 상세하되 단일 책임 유지 |
| 변경 이유 | 저장소 정책이나 작업 범위 변경 | 전문 workflow 또는 검증 방식 변경 |

`AGENTS.md`에는 skill 본문을 복제하지 않고 어떤 상황에서 어떤 skill을 사용할지 기록한다.

## 공통 Skill 분류

| 분류 | 책임 |
| --- | --- |
| incremental-implementation | 복잡한 변경을 검증 가능한 작은 단계로 나누는 절차 |
| debugging | 재현, 증거 수집, 원인 격리와 수정 검증 절차 |
| test-first | 실패 테스트, 최소 구현, 회귀 검증 흐름 |
| code-review | 정확성, 회귀, 보안, 테스트 누락 중심의 리뷰 절차 |
| refactoring | 동작 보존 확인과 작은 구조 개선 절차 |
| api-design-review | resource, HTTP 의미, 호환성, error contract 검토 |
| security-review | 입력, 인증·인가, secret, dependency 위험 검토 |
| commit-worklog | 변경 범위 확인, 검증, commit과 작업 기록 절차 |
| project-bootstrap | 신규 저장소의 최소 구조와 지침 초기화 절차 |

공통 skill은 특정 language나 framework를 필수 전제로 삼지 않는다.

## Stack-specific Skill 분류

Stack-specific skill은 해당 생태계에서만 의미가 있는 전문 작업에 한정한다.

- language: Java/Kotlin build 진단, Python packaging, JavaScript module migration 등
- framework/platform: Spring transaction 진단, React rendering 분석, Flutter platform 연동 검증 등
- database: RDB migration 검토, NoSQL access pattern 검증 등
- architecture/API: 모듈 경계 검사, 서비스 분리 검토, REST API 호환성 점검 등

여러 stack을 동시에 전제하는 절차는 한쪽 stack skill에 넣지 않고 조합 전용 skill 또는 bridge와 연결한다.

## Skill 필수 구성

각 skill은 다음 내용을 명확히 제공해야 한다.

### 목적

해결하려는 작업과 skill이 책임지지 않는 범위를 설명한다.

### 사용 조건

명시 호출 여부, 적용 가능한 작업 유형, 필요한 입력과 사용하지 말아야 할 조건을 정의한다.

### 절차

사실 확인부터 변경, 단계별 검증까지 재현 가능한 순서와 중요한 분기를 정의한다.

### 검증 기준

실행할 검사, 기대 결과, 실패 시 중단하거나 되돌아볼 조건을 정의한다.

### 금지 패턴

범위 밖 변경, 근거 없는 추정, 위험한 명령, 검증 생략 등 해당 workflow에서 허용하지 않는 행동을 명시한다.

### 완료 기준

어떤 결과와 증거가 있어야 작업 완료로 보고할 수 있는지 정의한다. 실행하지 못한 검증과 남은 위험을 보고하는 기준도 포함한다.

## 설계 원칙

- 하나의 skill은 하나의 명확한 작업 목적을 가진다.
- 저장소 정책이나 stack 상시 규칙을 skill에 숨기지 않는다.
- 특정 도구 명령은 필요할 때만 포함하고 대체 검증 기준을 함께 설명한다.
- 입력과 결과를 secret 또는 로컬 환경에 종속시키지 않는다.
- skill 간 의존은 최소화하고 순환 참조를 허용하지 않는다.
- 공통 절차와 stack-specific 세부 절차가 겹치면 공통 흐름은 재사용하고 차이만 분리한다.

Phase 0에서는 위 구조와 분류만 확정한다. 실제 skill 디렉터리, `SKILL.md`, 실행 script 또는 설치 기능은 만들지 않는다.
