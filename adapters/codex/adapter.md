# Codex Adapter 설계

## 대상 Agent

- Agent 식별자: `codex`
- 지원 범위: Codex용 전역·저장소 지침, skill 배치와 명시적으로 선택된 hook 설정의 논리적 변환 계약
- 현재 상태: 설계 초안이며 변환기와 실제 설정 파일 생성은 지원하지 않음

## 목적

에이전트 중립 profile, fragment와 skill을 Codex가 소비할 수 있는 지침 구조로 표현한다. Codex 전용 경로와 기능 차이는 이 adapter 안에 제한하고 원본 정책의 의미와 우선순위를 바꾸지 않는다.

## 입력 Source

- Profile manifest의 필수·선택 fragment, bridge, skill과 output 제약
- `core/global/agents.fragment.md`와 `core/project/agents.fragment.md`
- `core/quality/agents.fragment.md` 및 선택된 stack fragment
- 선택된 bridge `agents.fragment.md`
- Profile이 참조하는 common·stack-specific `SKILL.md`
- Merge 결과의 중복 제거, 충돌 진단과 미지원 기능 목록

입력은 adapter 진입 전에 variant와 pending 상태가 해소되고 `docs/merge-policy.md`에 따라 논리적으로 검증되어야 한다.

## 출력 파일

| 출력 대상 | 책임 |
| --- | --- |
| 전역 `~/.codex/AGENTS.md` | 프로젝트와 무관한 global 작업 원칙 |
| 저장소 `AGENTS.md` | 프로젝트 목표, stack·bridge 규칙, skill 선택 기준과 검증 명령 |
| 저장소 또는 사용자 skill directory | 선택된 `SKILL.md`를 Codex가 찾을 수 있는 범위에 배치하는 논리적 대상 |
| 저장소 `.codex/hooks.json` | Profile과 project가 명시적으로 선택한 Codex hook 선언의 대상 |

현재 단계에서는 위 경로나 파일을 실제로 생성·수정하지 않는다.

## 변환 규칙

- Global fragment는 전역 `AGENTS.md`에, project와 선택된 stack·bridge 규칙은 저장소 `AGENTS.md`에 배치한다.
- Quality 규칙은 중복을 제거한 뒤 관련 project/stack 규칙보다 일반적인 기준으로 유지한다.
- 긴 조건부 절차는 `AGENTS.md`에 복제하지 않고 skill 선택 조건과 식별 가능한 참조만 남긴다.
- Skill frontmatter의 trigger 의미와 본문을 보존하고 사용자/저장소 scope 선택은 project 정책으로 결정한다.
- Profile의 output section과 scope boundary를 Codex project template의 대응 placeholder에 mapping한다.
- Codex가 표현할 수 없는 source 의미는 삭제하지 않고 오류 또는 손실 진단으로 반환한다.
- 동일한 resolved profile과 project 입력은 동일한 논리적 section 및 참조 결과를 만들어야 한다.

## Codex 우선 정책

- Codex adapter를 최초 기준 adapter로 사용해 merge 결과, skill 분리와 의미 보존 검증 방식을 먼저 확정한다.
- Codex 전용 경로와 hook event를 core, fragment, skill 또는 profile의 공통 모델에 역으로 주입하지 않는다.
- Claude와 Gemini adapter는 Codex 파일을 번역하지 않고 동일한 중립 입력을 독립적으로 변환한다.
- Codex에서 지원되는 기능이 다른 agent에서도 지원된다고 가정하지 않는다.

## Git-auto Hook과의 관계

- 현재 저장소의 `.codex/hooks`와 `.codex/hooks.json`은 작업 기록용 git-auto 운영 설정이며 adapter 구현의 일부가 아니다.
- Adapter는 profile/project가 hook 출력을 명시한 경우에만 `.codex/hooks.json`을 논리적 출력 대상으로 다룬다.
- 기존 hook 설정을 덮어쓰거나 script를 생성하지 않고, 수동 설정과 충돌하면 자동 병합하지 않고 진단한다.
- Git-auto 사용 저장소의 직접 commit·push 금지와 `.gitauto/` 제외 정책을 생성 결과가 약화하지 않게 한다.
- Secret, token, database ID와 로컬 credential을 hook 출력 또는 진단에 포함하지 않는다.

## 지원하지 않는 기능

- Fragment merge, 충돌 해결, 파일 쓰기와 directory 설치
- 실제 Codex skill 설치·검색 경로 결정 및 배포
- Hook script 생성, event 실행과 기존 hook 자동 병합
- Profile pending 자동 해소와 target agent 자동 선택
- Codex version별 기능 차이의 자동 판정

미지원 기능이 필요한 profile은 부분 출력으로 성공 처리하지 않고 수동 검토 또는 구현 필요 상태로 진단한다.

## 검증 기준

- 모든 resolved fragment 규칙이 올바른 전역·project scope에 한 번만 반영된다.
- Profile이 선택한 skill과 `AGENTS.md`의 skill 진입 규칙이 추적 가능하다.
- Merge priority와 사용자·project 지침의 최종 권한이 유지된다.
- Git-auto hook이 있는 경우 기존 설정과 직접 commit·push 금지 정책이 보존된다.
- 미지원 기능, 의미 손실과 수동 결정이 누락 없이 보고된다.
- 출력 템플릿에는 미치환 placeholder가 최종 결과로 남지 않아야 한다.
