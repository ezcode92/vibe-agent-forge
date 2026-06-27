# Profile 명세

## Profile의 역할

Profile은 특정 프로젝트 유형에 필요한 stack fragment, bridge fragment, skill을 재현 가능한 하나의 조합으로 선언하는 선택 단위다. Profile 자체는 상세 작업 지침을 복제하지 않고, 무엇을 어떤 이유와 우선순위로 조합하는지를 표현한다.

Profile은 템플릿 프로젝트나 생성 결과가 아니다. 같은 profile이라도 저장소 고유 규칙은 project `AGENTS.md`에서 추가하거나 제한한다.

## 기술 스택 조합 방식

1. 프로젝트 유형에 맞는 language와 framework/platform을 선택한다.
2. 필요한 database, architecture, API, quality principle을 추가한다.
3. 선택 항목 사이의 결합 규칙이 있으면 bridge fragment를 포함한다.
4. 반복 작업 중 profile에서 사용할 공통·stack-specific skill을 연결한다.
5. merge 정책에 따라 중복과 충돌을 검증한 뒤 대상 adapter에 전달한다.

Profile은 구성 요소의 식별자를 참조하며 fragment 본문을 포함하지 않는다. 선택 순서는 merge priority를 대신하지 않는다.

## Profile manifest 정보

향후 manifest 형식을 정할 때 다음 정보를 표현할 수 있어야 한다. Phase 0에서는 필드 의미만 정의하며 YAML 파일이나 schema를 만들지 않는다.

| 정보 | 의미 |
| --- | --- |
| 식별자 | registry에서 중복되지 않는 안정적인 profile 이름 |
| 표시 이름과 설명 | 사용자에게 조합 목적과 대상 프로젝트 유형을 설명 |
| 상태와 버전 | draft·stable·deprecated 등 수명 주기와 호환성 기준 |
| 대상 에이전트 | 사용 가능한 adapter와 기능 제한 |
| stack 선택 | language, framework/platform, database, architecture, API, quality 항목 |
| fragment 참조 | 공통·stack·bridge fragment 식별자 목록 |
| skill 참조 | 기본 제공하거나 선택 가능한 skill 식별자 목록 |
| 조합 제약 | 필수 조합, 배타 조합, 지원하지 않는 조합 |
| override | profile 수준에서 명시적으로 바꾸는 제한된 정책과 근거 |
| 출력 정책 | 최종 지침의 대상, 크기 예산과 필수 section |

## 예시 Profile

다음 표는 조합 의도를 설명하는 문서 예시이며 실제 manifest가 아니다.

| Profile | 기본 조합 | 책임과 경계 |
| --- | --- | --- |
| `backend-kotlin-spring-rdb` | Kotlin, Spring, RDB, RESTful API | Kotlin/Spring 관례, transaction 경계, API·영속성 계약을 연결 |
| `backend-java-spring-rdb` | Java, Spring, RDB, RESTful API | Java/Spring 계층 책임과 RDB 변경·검증 원칙을 연결 |
| `python-cli-automation` | Python, CLI/automation 목적, maintainability, testability | 명시적 입출력, 안전한 shell·file 처리, 재실행 가능성과 단위 테스트 경계를 강조 |
| `frontend-react` | JavaScript, React, RESTful API client | component·state 책임과 backend API 계약 소비 경계를 정의 |
| `flutter-app` | Dart, Flutter, RESTful API client | widget·state·platform 책임과 remote API 경계를 정의 |
| `fullstack-spring-react` | Java 또는 Kotlin, Spring, JavaScript, React, RDB, RESTful API | backend와 frontend의 독립 규칙에 API contract bridge를 추가 |

`fullstack-spring-react`처럼 language 선택지가 있는 profile은 실제 manifest 단계에서 variant를 분리하거나 필수 parameter로 명시해야 한다. 암묵적인 기본 language를 선택하지 않는다.

## Profile 검증 원칙

- 참조하는 모든 구성 요소가 registry에 존재해야 한다.
- 필요한 기반 language와 bridge가 누락되지 않아야 한다.
- 배타 조합과 지원하지 않는 대상 adapter를 오류로 처리해야 한다.
- 동일 입력과 동일 구성 요소 버전은 같은 논리적 결과를 만들어야 한다.
- 저장소 고유 규칙을 profile에 넣어 재사용 범위를 오염시키지 않아야 한다.
