# Preview 및 Export Plan Flow

## 목적

Compatibility 검토가 끝난 profile 선택을 adapter별 논리 출력 구조로 보여 주고, 실제 파일 생성 전에 source, merge order, warning과 검증 항목을 확인하게 한다. Export는 실행이 아니라 향후 파일 작업 계획만 제공한다.

## Preview 입력 조건

- Project type과 필수 stack 선택 완료
- Variant 해소 또는 pending 수용 결정 기록
- Blocking conflict와 필수 bridge 누락 없음
- Adapter target 선택
- Project metadata 및 검증 명령의 존재 여부 확인

조건을 충족하지 못하면 Preview를 완성 결과로 표시하지 않고 해결 화면으로 연결한다.

## Adapter별 Preview 대상

| Adapter | Preview 대상 | Template |
| --- | --- | --- |
| Codex | Project `AGENTS.md` 논리 구조 | `templates/codex/AGENTS.md.template` |
| Claude | `CLAUDE.md` 논리 구조 | `templates/claude/CLAUDE.md.template` |
| Gemini | `GEMINI.md` 논리 구조 | `templates/gemini/GEMINI.md.template` |

Codex의 전역 `~/.codex/AGENTS.md`, skill directory와 hook 설정은 별도 output plan으로 표시하고 project preview에 무조건 합치지 않는다.

## Preview 구성

### Selected Fragments

- Base, quality, stack와 bridge category로 구분한다.
- Catalog ID, name, source path와 status를 보여 준다.
- Variant에서 선택된 fragment와 bridge는 선택 근거를 표시한다.

### Selected Skills

- Common과 stack-specific category로 구분한다.
- Trigger keyword, dependency와 profile 추천 근거를 보여 준다.
- Skill 본문 전체를 상시 지침에 삽입하지 않는다.

### Merge Order

- `fragments.yml.priority`와 `docs/merge-policy.md`를 기준으로 논리 순서를 표시한다.
- 동일 priority는 category, source와 profile override를 함께 보여 주고 임의 해결하지 않는다.
- Project 및 사용자 지침이 최종 권한임을 명시한다.

### Conflict Warnings

- Accepted pending, optional 미선택, adapter 미지원과 unregistered relation을 표시한다.
- Warning마다 source, 영향, 사용자 결정과 Resolver 이동점을 제공한다.

### Validation Checklist

- 모든 필수 reference가 존재한다.
- Dependency와 required bridge가 충족된다.
- Conflict와 variant 조건이 해소됐다.
- Adapter template과 output scope가 선택됐다.
- 미지원 output과 미치환 project metadata가 표시됐다.
- 실제 validation command가 확인됐거나 미정으로 표시됐다.

## Preview 표현 수준

현재 Preview는 다음 세 수준을 구분한다.

| 수준 | 내용 |
| --- | --- |
| Source summary | 선택 ID, path, priority와 warning |
| Template mapping | 어떤 placeholder에 어떤 source category가 연결되는지 |
| Logical outline | 실제 본문 없이 예상 section 순서와 누락 상태 |

완성된 fragment merge 본문이나 agent 설정 file content는 생성하지 않는다.

## Export Plan

Export Plan은 다음 항목을 읽기 전용으로 정리한다.

- Adapter와 예상 output path
- 신규/기존/충돌 상태를 사용자가 입력한 repository metadata로 분류한 결과
- Overwrite 금지, backup 후보와 review 순서
- Skill 및 user/global scope의 수동 설치 필요 여부
- Pending, unsupported output과 후속 구현 필요성
- Git-auto repository의 직접 commit·push 금지 안내

Export Plan은 download, clipboard용 완성 파일, archive, file write와 installer 실행을 제공하지 않는다.

## 현재 범위

Preview generator, merge engine, syntax validator와 export executor는 구현하지 않는다. 화면은 선택과 catalog metadata로 구성한 수동 검토용 outline만 보여 준다는 전제다.
