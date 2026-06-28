# Web UI 설계 개요

## 목적

VibeAgentForge Web UI는 registry catalog를 탐색하고 개발환경 profile을 선택·조합·검토하는 시각적 설계 도구다. 사용자가 fragment, bridge, skill과 adapter 관계를 YAML 파일 전체를 직접 비교하지 않고도 이해하게 하는 것이 목적이다.

현재 단계의 Web UI는 문서상 개념이다. 실제 browser 화면, frontend/backend application, API, database, generator와 installer는 존재하지 않는다.

## 해결하려는 문제

- Catalog 항목이 늘어날수록 사용 가능한 fragment와 skill을 수동으로 찾기 어렵다.
- Stack 조합에 필요한 bridge, conflict와 pending 관계를 profile 작성자가 놓칠 수 있다.
- Profile manifest와 registry catalog의 역할이 달라 선택 결과의 근거를 한눈에 보기 어렵다.
- Agent별 출력 대상과 미지원 기능을 adapter 문서까지 이동하며 비교해야 한다.
- 실제 파일 생성 전에 선택 항목, merge order와 검증 누락을 검토할 공통 화면이 없다.

Web UI는 이 문제를 조회, 선택, 추천, 진단과 preview 단계로 나눠 해결한다. 자동 수정이나 파일 쓰기로 넘어가지 않고 모든 추천의 근거를 사용자가 검토할 수 있게 한다.

## 사용 대상

| 사용자 | 주요 목적 |
| --- | --- |
| 프로젝트 초기 구성 담당자 | Project type과 stack에 맞는 profile 선택·조합 |
| 개발자 | Fragment, skill과 adapter 지원 범위 탐색 |
| 설계 검토자 | Compatibility, conflict, pending과 merge 결과 검토 |
| AgentForge 유지보수자 | Catalog 관계와 profile 누락을 사람이 확인 |

사용자는 YAML, 특정 agent 설정과 merge 정책의 세부 형식을 모두 알 필요는 없지만, 최종 선택과 conflict 해결 책임은 유지한다.

## Codex 우선 전략

- 최초 preview 기준은 Codex project `AGENTS.md` template로 삼는다.
- Codex의 전역/project 지침 분리와 skill 참조를 먼저 화면 모델로 검증한다.
- `.codex/hooks`와 git-auto는 기존 repository 운영 설정으로 취급하고 Web UI가 자동 수정하지 않는다.
- Codex 우선은 공통 모델을 Codex에 결합한다는 의미가 아니며 Claude·Gemini도 동일한 resolved profile을 입력으로 사용한다.
- Claude와 Gemini preview는 adapter capability와 미지원 항목을 명시한 뒤 확장한다.

## Profile Builder 중심 구조

Profile Builder가 Web UI의 중심 작업 화면이다. Dashboard와 Registry Browser에서 시작한 선택을 Builder에 가져오고, Compatibility Checker와 Conflict Resolver가 검토를 보조하며 Preview와 Export Plan이 결과를 읽기 전용으로 정리한다.

기본 흐름은 다음과 같다.

1. 기존 profile 또는 새 profile 초안을 선택한다.
2. Project type과 stack을 선택한다.
3. Bridge와 skill 추천을 검토한다.
4. Compatibility와 conflict를 확인한다.
5. Adapter target과 출력 scope를 선택한다.
6. Preview 전 체크리스트를 완료한다.
7. 읽기 전용 preview와 export 계획을 검토한다.

## Registry Catalog 소비 전제

Web UI는 다음 catalog를 읽는다고 가정한다.

- `registry/fragments.yml`: Fragment 선택, 의존, conflict와 priority
- `registry/skills.yml`: Skill 검색, trigger와 profile 추천
- `registry/profiles.yml`: 기존 profile 요약과 진입점
- `registry/adapters.yml`: Agent 대상, template와 미지원 출력
- `registry/compatibility-matrix.yml`: Stack 조합, 필수 bridge와 pending 관계

현재 catalog reader, API와 cache는 설계하지 않는다. UI 문서는 catalog field가 화면에서 어떤 의미로 사용되는지만 정의하며 YAML 구조를 변경하지 않는다.

## 현재 제외 범위

- Fragment merge engine과 validator
- 실제 `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` 생성
- Repository file write, backup, installer와 commit·push
- User account, 권한, 원격 저장소와 background sync
- Frontend/backend stack, API endpoint와 database schema 결정
- Mock server, component code와 배포 환경

Web UI가 보여 주는 추천, preview와 export plan은 모두 수동 검토용 설계 결과다.
