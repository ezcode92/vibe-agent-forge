# AgentForge

AgentForge는 Codex CLI, Claude Code, Gemini CLI 등 AI 코딩 에이전트를 위한 개발환경 최적화 설정 관리 도구입니다. 기술 스택 조합에 맞는 지침과 설정을 일관된 형태로 구성하고, 장기적으로 Web UI에서 이를 관리할 수 있는 확장 가능한 기반을 만드는 것을 목표로 합니다.

## 프로젝트 목표

- 에이전트 공통 설정과 프로젝트별 설정의 책임을 명확히 분리합니다.
- 기술 스택별 지침과 skill을 재사용 가능한 단위로 관리합니다.
- 선택한 스택과 profile에 따라 최종 에이전트 설정을 조합할 수 있는 구조를 설계합니다.
- 특정 AI 코딩 에이전트에 종속되지 않는 핵심 모델을 유지합니다.
- 향후 Web UI와 자동화 도구를 추가하기 쉬운 확장 지점을 마련합니다.

## 핵심 개념

- **global agent config**: 모든 프로젝트에 공통으로 적용하는 사용자 또는 조직 수준의 기본 지침입니다.
- **project AGENTS.md**: 저장소의 목적, 작업 방식, 제약을 정의하는 프로젝트 수준 지침입니다.
- **stack fragments**: 언어, 프레임워크, 데이터 저장소 등 기술 스택별 지침 조각입니다.
- **skills**: 길거나 전문적인 작업 절차와 도메인 지식을 독립적으로 관리하는 단위입니다.
- **profiles**: 목적이나 팀 환경에 맞춰 config, fragment, skill 조합을 정의하는 선택 단위입니다.
- **adapters**: Codex CLI, Claude Code, Gemini CLI 등 대상 에이전트의 설정 형식 차이를 흡수하는 계층입니다.
- **future Web UI**: profile과 기술 스택을 선택하고 생성 결과를 관리하는 장기 확장 인터페이스입니다.

## 초기 개발 단계

현재는 plan/design 중심의 초기 단계입니다. 구현에 앞서 용어, 디렉터리 책임, 문서 구조, 설정 조합 규칙과 확장 경계를 정의합니다. 초기 저장소는 문서 중심 구조를 유지하며 각 디렉터리의 역할을 명시하는 데 집중합니다. 단, Codex 작업 기록 자동화를 위한 최소 hook 설정은 예외적으로 포함합니다.

MVP generator도 현재는 profile과 registry를 검증해 agent 설정 preview를 구성하는 설계 단계이며, 실제 generator code와 파일 생성 기능은 구현하지 않습니다.

Phase 9에서는 `backend-kotlin-spring-rdb` profile과 Codex adapter를 대상으로 문서 기반 manual dry-run을 수행해 preview 조합 가능성을 검증합니다. Dry-run example은 실제 agent 설정으로 export하지 않습니다.

Dry-run에서 확인된 Spring–Modular Monolith bridge와 정량 output size budget 누락은 설계 문서와 registry/profile 수준에서 보강하며, 실제 generator 구현 범위는 계속 제외합니다.

## 아직 구현하지 않을 것

초기 단계에서는 다음 항목을 구현하지 않습니다.

- generator
- installer
- Web UI
- multi-agent adapter

## 디렉터리 구조

- `docs/`: 아키텍처와 설계 문서
- `core/`: 에이전트 중립적인 핵심 개념과 규칙 문서
- `stacks/`: 기술 스택별 fragment 문서
- `skills/`: 재사용 가능한 전문 지침 문서
- `profiles/`: 설정 조합과 적용 목적 문서
- `adapters/`: 에이전트별 변환 경계 문서
- `templates/`: 생성 대상 문서의 템플릿 정의
- `registry/`: 사용 가능한 구성 요소의 목록과 메타데이터 정의
