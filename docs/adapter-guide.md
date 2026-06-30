# Agent Adapter 가이드

## 목적

Adapter 계층은 AgentForge의 에이전트 중립 profile, fragment와 skill을 Codex, Claude, Gemini가 소비하는 파일 및 설정 개념으로 표현한다. 공통 정책을 agent별 파일에 직접 복제해 독립 관리하지 않고 하나의 중립 source에서 의미 동등한 결과를 만들기 위한 마지막 변환 경계다.

현재 adapter는 계약 문서와 placeholder template만 제공한다. Fragment merge, 파일 생성, 설치, settings 수정과 agent 실행은 구현하지 않는다.

## Core, Profile, Fragment, Skill과의 관계

1. Profile이 필수 core, stack, bridge fragment와 skill을 선택한다.
2. Variant와 pending 상태를 해결하고 모든 필수 참조를 검증한다.
3. Merge 계층이 중복, 충돌과 priority를 처리해 agent 중립 논리 결과를 만든다.
4. Adapter가 target agent capability를 확인하고 논리 section, skill과 확장 설정을 대상 구조에 mapping한다.
5. 미지원 기능과 의미 손실을 진단하고 출력 후보를 검증한다.

Adapter는 profile 선택이나 fragment 충돌 해결을 대신하지 않는다. 입력이 불완전하면 임의 기본값을 선택하지 않고 앞 단계로 오류를 반환한다.

## Adapter가 해야 할 일

- 중립 section을 대상 agent의 지침 문서와 scope에 mapping한다.
- Global, project, user/local 설정의 공유 범위를 구분한다.
- Skill trigger와 본문을 대상 agent의 지원 방식에 맞춰 연결하거나 미지원으로 진단한다.
- Hook, command, MCP 등 agent 전용 기능은 profile/project가 명시하고 capability가 확인된 경우에만 mapping한다.
- Source 출처, override와 손실 가능성을 추적 가능한 진단으로 남긴다.
- 동일 resolved 입력에 대해 결정적인 논리 결과를 만든다.

## Adapter가 하지 말아야 할 일

- Core, fragment, skill과 profile의 정책 의미를 새로 정의하거나 약화하지 않는다.
- 해결되지 않은 merge 충돌, variant와 pending을 임의로 선택하지 않는다.
- 다른 agent의 경로와 기능 이름만 바꾸어 동등하다고 가정하지 않는다.
- Secret과 user-local 설정을 project 공유 파일에 넣지 않는다.
- 실제 파일 쓰기, generator, installer, hook script와 Web UI 역할을 수행하지 않는다.

## Codex 우선 개발 전략

Codex adapter를 첫 기준으로 삼아 전역/project 지침 분리, skill 참조, hook 충돌 진단과 출력 검증 계약을 먼저 구체화한다. 이는 Codex 형식을 공통 모델로 채택한다는 의미가 아니다. Codex 전용 경로와 event는 adapter 내부에 남기고 core/profile 구조는 계속 agent 중립으로 유지한다.

Codex 구현 전에도 현재 저장소의 `.codex/hooks`는 git-auto 작업 기록용 운영 설정으로 보존한다. Adapter 설계 또는 향후 생성 결과가 이 hook을 자동 변경하거나 직접 commit·push 정책을 우회하지 않아야 한다.

## Claude 및 Gemini 확장 전략

- Claude와 Gemini adapter는 Codex 출력물을 입력으로 사용하지 않고 동일한 resolved profile을 입력으로 사용한다.
- 각 agent의 settings scope, skill/command/hook 또는 MCP capability를 독립적으로 확인한다.
- 기능이 없는 경우 상시 지침으로 억지로 펼치지 않고 미지원 또는 수동 mapping으로 진단한다.
- 파일 구조가 달라도 사용자 요청, project 제한, 검증과 금지 규칙의 의미 동등성을 비교한다.
- Agent version별 차이는 실제 adapter 구현 단계에서 capability metadata로 분리한다.

## Adapter별 출력 비교

| Adapter | 기본 지침 출력 | 설정 scope | 조건부 절차·확장 영역 | 현재 상태 |
| --- | --- | --- | --- | --- |
| Codex | 전역 `~/.codex/AGENTS.md`, repo `AGENTS.md` | User/global 및 repository | User/repo skill directory, `.codex/hooks.json` | `mvp-contract` |
| Claude | `CLAUDE.md` | Project/local settings 개념 | Hooks, commands, skills 확장 영역 | `draft` |
| Gemini | `GEMINI.md` | Workspace/user settings 개념 | MCP/settings 확장 영역 | `draft` |

표의 출력 대상은 구현 완료나 현재 agent version의 지원 보장을 뜻하지 않는다. 실제 adapter 구현 전에 공식 capability, scope와 충돌 정책을 확인해야 한다.

## Profile Manifest 전달 방식

- 수동 검토 단계에서 profile의 `target_agents`와 `adapters`는 비어 있으며 adapter 선택은 별도 입력으로 제공한다.
- Adapter에는 선택형 variant가 해소되고 pending이 허용 범위 내에서 처리된 resolved profile만 전달한다.
- `base_fragments`, `quality_rules`, `stacks`, `bridges`, `skills` 참조와 `output`, `constraints`를 함께 전달한다.
- Adapter는 profile 경로를 직접 이어 붙이지 않고 앞 단계가 제공한 merge 결과와 source metadata를 사용한다.
- Profile output의 필수 section과 size budget을 대상 template 검증 기준으로 사용한다.

## Template 사용 원칙

- `templates/codex/AGENTS.md.template`은 Codex `mvp-contract`와 호환되고 Claude/Gemini template은 `draft` adapter의 논리적 output shape를 검토한다.
- `<...>` placeholder는 향후 generator가 검증된 입력으로 치환할 위치를 나타낸다.
- Template에는 실제 fragment 본문, project secret, 명령과 선택되지 않은 skill을 넣지 않는다.
- 미치환 placeholder가 있는 결과는 완성된 agent 설정으로 간주하지 않는다.

## 현재 범위

현재 Codex `mvp-contract`, Claude/Gemini `draft` adapter 문서와 output template이 존재한다. 실제 adapter code, merge engine, generator, installer, settings/hook 생성과 Web UI는 구현하지 않는다.
