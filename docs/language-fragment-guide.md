# Language Fragment 가이드

## 목적

Language fragment는 특정 언어를 선택했을 때 모든 프로젝트에서 유지되는 타입, module, 오류, 비동기 처리와 관용적 작성 원칙을 제공한다. Core quality 원칙을 언어 기능으로 구체화하되 framework, platform, database와 architecture의 책임을 가져오지 않는다.

각 fragment는 독립적으로 선택 가능해야 한다. Language 항목이 registry에 등록되었다는 사실은 특정 framework 조합이나 실행 환경까지 지원한다는 의미가 아니다.

## Framework 및 Platform Fragment와의 분리

Language와 framework/platform은 변경 이유와 적용 조건이 다르다. 같은 언어는 여러 framework, library 또는 독립 실행 환경에서 사용될 수 있고, framework 규칙은 component 생성, lifecycle, 설정, I/O 경계와 test 방식처럼 선택한 실행 모델에만 유효하다.

따라서 language fragment는 문법, 타입과 표준적인 제어 흐름만 책임진다. Framework/platform fragment는 기반 language 규칙을 반복하지 않고 자신이 추가하는 lifecycle과 구성 규칙만 정의한다. 이 분리를 유지하면 한쪽 변경이 무관한 조합에 전파되지 않고 중복 및 충돌을 독립적으로 진단할 수 있다.

## Bridge Fragment가 필요한 경우

Language 기능을 framework/platform의 lifecycle, proxy, 상태 관리 또는 생성 규칙에 연결해야 하면 한쪽 fragment에 규칙을 넣지 않고 bridge로 분리한다.

| Bridge 예시 | 연결 책임의 예시 |
| --- | --- |
| `kotlin-spring` | Kotlin nullability, coroutine과 Spring의 component·transaction lifecycle 사이의 경계 |
| `java-spring` | Java type·exception 모델과 Spring의 proxy·configuration·transaction 경계 |
| `dart-flutter` | Dart Future·Stream과 Flutter widget·state lifecycle 사이의 정리 및 오류 전달 경계 |
| `javascript-react` | JavaScript module·async·immutable update와 React component·rendering·state 경계 |

위 표는 bridge가 필요한 책임을 설명하는 설계 예시다. 실제 bridge fragment나 세부 규칙을 정의하지 않으며, 각 bridge는 두 항목이 함께 선택될 때만 적용한다.

## Language Fragment에 넣지 않는 내용

- Framework annotation, component 등록, dependency injection과 lifecycle callback
- UI component, rendering, navigation, platform channel과 상태 관리 방식
- Database schema, ORM mapping, transaction과 query 최적화 규칙
- Architecture 계층, 서비스 분리, 배포 topology와 network 계약
- 특정 build tool, plugin, package 또는 library의 설치·설정 절차
- 특정 작업에서만 필요한 긴 debugging, migration과 test workflow
- 둘 이상의 stack이 함께 있어야만 의미가 생기는 조합 규칙

Build, lint와 test 도구는 실제 프로젝트가 선택한 설정을 확인하는 검증 범주로만 언급한다. 특정 명령이나 도구를 모든 프로젝트에 강제하지 않는다. 조건부 전문 절차는 skill로, 조합 규칙은 bridge fragment로 분리한다.

## 작성 및 검증 기준

- `templates/agents-fragment.template.md`의 필수 section을 유지한다.
- 규칙마다 해당 언어 선택 때문에 달라지는 판단인지 확인한다.
- 사용하려는 언어 기능이 프로젝트의 지원 버전과 compiler 또는 runtime 설정에 맞는지 확인한다.
- Framework 이름이 필요하다면 bridge 필요 조건을 설명하는 수준으로 제한하고 구현 규칙을 포함하지 않는다.
- Core와 다른 language fragment의 규칙을 복제하지 않고 참조 가능한 책임 경계를 유지한다.

## 현재 범위

현재 Java, Kotlin, Python, JavaScript와 Dart language fragment 5개가 존재하며 framework/platform fragment, bridge, skill, profile과 registry에 연결된다. 이 문서는 language fragment의 책임을 정의하며 실행 코드, generator와 installer는 포함하지 않는다.
