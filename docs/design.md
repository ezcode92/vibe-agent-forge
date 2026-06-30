# VibeAgentForge 전체 설계와 단계 체계

## 프로젝트 목적

VibeAgentForge(이하 AgentForge)는 프로젝트의 기술 스택과 운영 방식에 맞는 AI 코딩 에이전트 설정을 일관되게 구성하기 위한 설계 기반이다. 공통 작업 원칙, 프로젝트 규칙, 기술 스택별 지침, 전문 작업 절차를 서로 다른 책임 단위로 관리하고 필요한 조합만 선택할 수 있게 하는 것이 목적이다.

AgentForge는 우선 Codex에서 사용할 `AGENTS.md`, fragment, skill의 구조를 정의한다. 특정 에이전트의 파일 형식을 핵심 모델에 직접 결합하지 않고, 향후 Claude Code와 Gemini CLI로 확장할 수 있는 경계를 함께 설계한다.

## 핵심 문제

- 전역 지침과 프로젝트 지침이 한 문서에 섞이면 적용 범위와 변경 책임이 불명확해진다.
- 여러 기술 스택의 지침을 단순히 이어 붙이면 중복, 모순, 과도한 context 사용이 발생한다.
- 긴 절차를 `AGENTS.md`에 계속 추가하면 모든 작업에서 불필요한 지침을 읽게 된다.
- 에이전트별 설정 형식을 직접 관리하면 같은 정책이 여러 파일에 복제되고 서로 다르게 변경될 수 있다.
- profile의 조합 기준과 충돌 해결 규칙이 없으면 같은 입력에서도 결과가 달라질 수 있다.

## 해결 구조

AgentForge는 다음 책임 단위로 설정을 분리한다.

| 구성 요소 | 책임 |
| --- | --- |
| global config | 프로젝트와 무관하게 반복 적용되는 사용자·조직 공통 원칙 |
| project config | 저장소의 목적, 제약, 검증 방법과 변경 규칙 |
| stack fragment | 하나의 언어, 프레임워크, 플랫폼, 데이터베이스 또는 아키텍처에 고유한 지침 |
| bridge fragment | 둘 이상의 스택을 함께 사용할 때만 필요한 연결 규칙 |
| skill | 특정 조건에서 호출하는 전문 작업 절차와 완료 기준 |
| profile | 프로젝트 유형에 필요한 fragment와 skill의 조합 선언 |
| adapter | 에이전트 중립적인 구성을 대상 에이전트 형식으로 변환하는 경계 |
| registry | 사용 가능한 구성 요소의 식별자와 관계를 찾기 위한 목록 |

구성 결과는 profile 선택, 구성 요소 조회, 우선순위 기반 병합, 충돌 검증, 대상 에이전트 형식 변환의 순서로 만들어지는 것을 전제로 한다. Phase 0에서는 이 흐름의 책임과 규칙만 정의하며 실행기는 만들지 않는다.

## 에이전트 확장 방향

### Codex 우선

- 최초 기준 형식은 Codex의 전역 `~/.codex/AGENTS.md`, 저장소 `AGENTS.md`, skill 구조로 삼는다.
- 현재 `.codex/hooks`는 설정 생성 기능이 아니라 git-auto 작업 기록 자동화를 위한 저장소 운영 예외다.
- Codex 전용 경로와 이벤트 형식은 adapter 책임으로 한정하고 핵심 profile이나 stack 정의에 넣지 않는다.

### Claude Code와 Gemini CLI 확장

- 공통 정책과 stack 지침은 에이전트 중립적인 원본으로 유지한다.
- 에이전트마다 지원하는 지침 파일, skill 호출 방식, hook 기능의 차이는 별도 adapter가 해석한다.
- 대상 에이전트가 지원하지 않는 기능은 핵심 모델을 변경하지 않고 adapter의 지원 범위 또는 진단 결과로 표현한다.
- 여러 adapter가 동일한 정책 의미를 유지하는지 검증할 수 있어야 한다.

## 현재 하지 않을 것

현재 문서·설계 단계에서는 다음 항목을 구현하지 않는다.

- fragment 병합기와 generator
- 로컬·원격 installer
- Web UI와 관리 API
- Claude Code·Gemini CLI adapter 실행 기능
- 배포, 버전 업데이트, 원격 동기화 기능

Profile YAML, registry catalog, fragment, skill과 adapter 계약 문서는 이미 존재한다. 이 자산의 존재와 실제 조합·설치 기능 구현을 구분한다.

## 현재 Phase 구분

| Phase | 상태 | 주요 결과 |
| --- | --- | --- |
| Phase 0 | 완료 | 책임 경계, stack catalog, profile 명세, merge와 skill 설계 기준 |
| Phase 1 | 완료 | Skeleton 디렉터리, README와 template 구조 |
| Phase 2 | 완료 | Core·language·framework/platform·database/API/architecture·bridge fragment 체계 |
| Phase 3 | 완료 | Common, backend/database/testing/automation, frontend/mobile skill 체계 |
| Phase 4 | 완료 | 6개 profile manifest와 variant·constraint 표현 |
| Phase 5 | 완료 | Codex·Claude·Gemini adapter 설계; Codex만 `mvp-contract` |
| Phase 6 | 완료 | Fragment·skill·profile·adapter·compatibility registry catalog |
| Phase 7 | 완료 | Web UI의 정보 구조, flow, 데이터 모델과 MVP 범위 설계 |
| Phase 8 | 진행 중 | Generator 계약과 pipeline 설계; 구현 전 결정사항은 미확정 |
| Phase 9 | 완료 | Codex profile 및 fullstack language variant manual dry-run 6종 |
| Phase 10-1 | 완료 | 문서 상태, Phase와 lifecycle 설명 정합화 |

Phase 상태는 문서·설계 산출물의 진행도를 나타낸다. Catalog의 `draft`, adapter의 `mvp-contract`, dry-run의 `ready` 같은 lifecycle/readiness 상태와 동일한 축이 아니다. 상태 의미와 승격 기준은 `lifecycle-status-policy.md`를 따른다.

## 장기 구현 방향

현재 Phase 체계 이후 실제 구현을 승인할 경우에는 Codex 조합 기능, 다중 agent 확장, 배포·관리 기능 순으로 검토한다. 이 방향에는 merge engine, validator, generator, adapter 실행 기능, installer와 Web UI가 포함될 수 있지만 현재 작업 범위나 구현 승인을 뜻하지 않는다.
