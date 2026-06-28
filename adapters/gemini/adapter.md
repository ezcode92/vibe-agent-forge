# Gemini Adapter 설계

## 대상 Agent

- Agent 식별자: `gemini`
- 지원 범위: Gemini용 workspace 지침과 user/workspace settings, MCP 확장 지점의 개념적 mapping
- 현재 상태: 설계 초안이며 실제 Gemini 설정 형식과 파일 생성은 지원하지 않음

## 목적

에이전트 중립 profile, fragment와 skill을 Gemini가 소비할 수 있는 workspace 지침 및 설정 확장 구조로 표현하는 경계를 정의한다. Codex 또는 Claude 전용 기능을 Gemini 공통 기능으로 가정하지 않는다.

## 입력 Source

- Resolved profile manifest와 output·constraint
- Core, quality, stack 및 bridge fragment의 충돌 검증 결과
- Profile이 선택한 common·stack-specific skill
- Project별 검증 명령, 완료 기준과 scope boundary
- Target agent capability, MCP 요구와 미지원 기능 진단

## 출력 파일

| 출력 대상 | 책임 |
| --- | --- |
| Workspace `GEMINI.md` | 프로젝트 목표, 작업 규칙, stack·bridge 지침과 검증 기준 |
| Workspace/user settings 개념 | 공유 project 설정과 사용자 설정의 분리 대상 |
| MCP/settings 확장 영역 | 명시적으로 선택된 외부 tool·context 연결의 후보 |

현재 단계에서는 `GEMINI.md`, settings와 MCP 설정 파일을 실제로 생성하지 않는다.

## 변환 규칙

- Workspace에 항상 필요한 규칙만 `GEMINI.md`에 두고 조건부 skill은 지원 capability에 맞는 참조 또는 진단으로 분리한다.
- Profile의 fragment·bridge 의미와 merge priority를 유지하고 Gemini 파일 구조를 core 모델에 역으로 반영하지 않는다.
- Workspace와 user settings는 공유 가능성, secret과 로컬 override를 기준으로 분리한다.
- MCP 연결은 profile의 명시적 요구와 권한 범위가 있을 때만 mapping 후보로 삼고 자동 추가하지 않는다.
- Skill의 목적, trigger, 검증과 완료 기준을 보존할 수 없으면 본문을 무조건 삽입하지 않고 수동 mapping을 요구한다.
- Codex/Claude 전용 hook, command와 skill packaging은 Gemini settings로 단순 경로 변환하지 않는다.

## Codex와 다른 점

- `AGENTS.md` 대신 `GEMINI.md`를 workspace 지침 출력 대상으로 사용한다.
- Codex의 전역/project AGENTS 계층, skill directory와 hook 설정을 Gemini 구조로 자동 복제하지 않는다.
- MCP/settings 확장은 지침 문서와 별도 권한·연결 경계로 취급한다.
- 출력 파일의 동일성보다 중립 정책 의미, scope와 금지 규칙의 동등성을 검증한다.

## 지원하지 않는 기능

- 실제 Gemini settings schema와 MCP server 설정 생성
- Codex hook 또는 Claude command/skill 구조의 자동 이식
- 미확인 Gemini 기능에 대한 skill 호출 동등성 보장
- Fragment merge, workspace/user settings 수정과 파일 설치
- Agent version별 capability 자동 탐지

지원되지 않는 입력은 삭제하지 않고 오류, 경고 또는 수동 변환 대상으로 표시한다.

## 검증 기준

- `GEMINI.md` 후보가 profile의 project 규칙, 검증과 scope boundary를 보존한다.
- Workspace/user settings 및 MCP의 권한·secret 경계가 구분된다.
- Conditional skill이 상시 workspace 지침으로 무조건 확장되지 않는다.
- 다른 agent 전용 기능이 Gemini 지원 기능으로 잘못 간주되지 않는다.
- 미지원 기능과 수동 mapping 요구가 추적 가능하다.
- 동일 resolved 입력은 동일한 논리적 Gemini 출력 계약을 만든다.
