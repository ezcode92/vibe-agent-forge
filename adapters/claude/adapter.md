# Claude Adapter 설계

## 대상 Agent

- Agent 식별자: `claude`
- 지원 범위: Claude용 저장소 지침과 project/local settings, hooks·commands·skills 확장 지점의 개념적 mapping
- 현재 상태: 설계 초안이며 실제 Claude 설정 형식과 파일 생성은 지원하지 않음

## 목적

에이전트 중립 profile, fragment와 skill의 의미를 Claude가 소비할 수 있는 지침 및 확장 구조로 변환하는 경계를 정의한다. Codex 전용 경로와 hook 의미를 그대로 복제하지 않는다.

## 입력 Source

- Resolved profile manifest와 output·constraint
- Core, quality, stack 및 bridge fragment의 충돌 검증 결과
- Profile이 선택한 common·stack-specific skill
- Project별 명령, scope boundary와 완료 기준
- Target agent capability 및 미지원 기능 진단

## 출력 파일

| 출력 대상 | 책임 |
| --- | --- |
| 저장소 `CLAUDE.md` | 프로젝트 목표, 작업 규칙, stack·bridge 지침과 검증 기준 |
| Project/local settings 개념 | 저장소 공유 설정과 사용자 로컬 설정의 분리 대상 |
| Hooks 확장 영역 | 명시적으로 지원·선택된 lifecycle automation의 연결 지점 |
| Commands/skills 확장 영역 | 조건부 작업 절차를 Claude가 호출 가능한 구조로 표현할 후보 |

현재 단계에서는 `CLAUDE.md`, settings, hooks, commands와 skills 파일을 실제로 생성하지 않는다.

## 변환 규칙

- 항상 필요한 project 규칙만 `CLAUDE.md`에 두고 긴 조건부 절차는 확장 가능한 skill/command 영역으로 분리한다.
- Global과 local scope는 Claude 대상 환경의 지원이 확인된 범위에서 mapping하고 확인되지 않으면 수동 결정으로 남긴다.
- Profile의 fragment 순서가 아니라 merge 결과의 의미, 구체성과 출처를 기준으로 section을 구성한다.
- Codex hook 설정은 Claude hook으로 자동 번역하지 않고 lifecycle 의미가 동등한지 먼저 진단한다.
- Skill trigger, 입력, 절차와 완료 기준을 보존하되 Claude가 지원하지 않는 호출 방식은 손실 진단으로 표시한다.
- Settings 값, secret과 사용자 로컬 정보는 project 공유 출력에 포함하지 않는다.

## Codex와 다른 점

- `AGENTS.md` 대신 `CLAUDE.md`를 project 지침 출력 대상으로 사용한다.
- Codex skill 및 hook directory 구조를 Claude의 commands/skills/hooks로 경로 치환하지 않는다.
- Project/local settings의 공유 범위와 override 의미를 Claude capability에 맞춰 별도로 결정한다.
- Codex 기준 결과와 문장·파일 구조가 같아야 하는 것이 아니라 정책 의미와 금지 범위가 동등해야 한다.

## 지원하지 않는 기능

- 실제 Claude settings schema, hook event와 command/skill package 생성
- Codex 전용 `.codex/hooks.json`과 git-auto script의 자동 이식
- 미확인 Claude 기능에 대한 무손실 mapping 보장
- Fragment merge, 파일 설치와 local settings 수정
- Agent version별 capability 자동 탐지

지원되지 않는 입력은 조용히 제외하지 않고 오류, 경고 또는 명시적 수동 mapping 대상으로 분류한다.

## 검증 기준

- `CLAUDE.md` 후보가 profile의 필수 project 규칙과 scope boundary를 보존한다.
- Conditional skill 본문이 상시 지침에 중복 삽입되지 않는다.
- Project/local settings와 secret의 공유 범위가 분리된다.
- Codex 전용 기능이 근거 없이 Claude 지원 기능으로 변환되지 않는다.
- 미지원 기능과 의미 차이가 출력별로 추적 가능하다.
- 동일 resolved 입력은 동일한 논리적 Claude 출력 계약을 만든다.
