# AGENTS.md

## 저장소 목적

이 저장소는 Codex CLI, Claude Code, Gemini CLI 등 AI 코딩 에이전트의 개발환경 설정을 기술 스택에 맞게 구성하고 관리하기 위한 AgentForge의 설계 기반을 정의합니다.

## 현재 단계

현재는 plan/design 중심 단계입니다. 실행 코드 생성보다 개념, 책임 경계, 문서 구조와 조합 규칙의 설계를 우선합니다. 명시적으로 합의되지 않은 generator, installer, Web UI 또는 adapter 구현을 추가하지 않습니다.

## 설정 구성 방향

- 전역 설정과 프로젝트 설정을 분리합니다.
- 전역 설정에는 여러 프로젝트에서 공통으로 유지할 원칙만 둡니다.
- 프로젝트 설정에는 해당 저장소의 목적, 제약과 작업 규칙을 둡니다.
- 기술 스택별 `agents.fragment.md`와 skill을 조합해 최종 `AGENTS.md`를 생성하는 방향으로 설계합니다.
- 긴 지침과 전문 절차는 최종 `AGENTS.md`에 직접 누적하지 않고 skill 또는 `docs/`로 분리합니다.
- 둘 이상의 기술 스택 사이에서만 필요한 조합 규칙은 bridge fragment로 분리합니다.

## 지원 예정 스택

- Java
- Kotlin
- Python
- JavaScript
- React
- Flutter
- Spring
- RDB
- NoSQL

## 설계 원칙

- 새로운 언어, 프레임워크, 에이전트를 독립적으로 추가할 수 있는 확장성을 확보합니다.
- 구성 요소의 책임과 의존성을 명확히 하여 유지보수성을 높입니다.
- SOLID와 객체지향 원칙을 적용하되 문제의 규모와 변경 가능성에 맞게 사용합니다.
- 디자인 패턴을 목적 없이 과도하게 적용하지 않습니다.
- HTTP API를 설계할 때 RESTful 원칙을 준수합니다.
- 각 언어와 생태계가 권장하는 철학, 관례와 도구를 존중합니다.

## 변경 시 주의사항

- 현재 단계에 필요하지 않은 구현을 추가하지 않습니다.
- 코드보다 문서 구조와 책임 경계를 먼저 확정합니다.
- 긴 지침은 `AGENTS.md`가 아니라 skill 또는 `docs/`로 분리합니다.
- 기술 조합에만 적용되는 규칙은 개별 stack fragment가 아니라 bridge fragment로 분리합니다.
- 기존 용어와 디렉터리 책임을 변경할 때 관련 문서를 함께 갱신합니다.
## Codex 작업 기록 hook

- `.codex/hooks`는 Codex 작업 종료 시 git-auto를 통해 GitHub와 Notion에 작업 기록을 자동화하기 위한 최소 hook 설정입니다.
- hook이 생성하는 `.gitauto/` 산출물은 Git에 commit하지 않습니다.
