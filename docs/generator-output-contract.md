# Generator 출력 계약

## 목적

MVP generator가 성공·조건부 성공·실패 시 반환해야 할 preview와 진단 정보를 정의한다. Output은 UI/CLI/API schema가 아니라 구현 독립적인 논리 결과다.

## 최소 출력

### Preview Content

- Adapter template을 기준으로 구성한 project 지침의 논리적 preview다.
- 필수 placeholder가 해소됐는지와 source provenance를 유지한다.
- 실제 filesystem content로 쓰지 않는다.

### Included Fragments

- ID, name, category, path, priority와 선택 근거
- Profile 기본, variant, optional과 bridge 여부
- 중복 제거 또는 대체된 source 상태

### Included Skills

- ID, category, path, trigger와 선택 근거
- Profile 기본/optional 및 dependency
- Lazy-loaded, not-loaded와 adapter unsupported 상태

### Merge Order

- Section 구성 순서와 authority priority를 구분한 ordered source 목록
- Override 대상, source와 근거
- Deduplication 및 대체 관계

### Warnings

- Pending, unregistered relation, 미확정 metadata, output length와 optional 미선택
- Preview 가능 여부와 사용자가 검토할 action

### Conflicts

- Conflict ID, type, severity, source, 영향과 권장 해결 방향
- Blocking 여부와 관련 pipeline 단계

### Validation Checklist

- YAML parse, path, ID, dependency, compatibility, bridge, adapter와 length 검증 상태
- `passed`, `failed`, `warning`, `not-run`을 구분한다.

### Unsupported Features

- Adapter가 지원하지 않는 output, skill mapping, hook/settings와 수동 처리 필요성
- 조용히 생략하지 않고 source와 영향 표시

## 공통 Output Metadata

| 항목 | 의미 |
| --- | --- |
| `profileId` | 선택 profile ID |
| `adapterId` | Target adapter ID |
| `catalogVersion` | 사용한 catalog version 집합 |
| `previewStatus` | `ready`, `ready-with-warnings`, `blocked` |
| `generatedAt` | 향후 실행 시점 metadata 후보, 현재 계약에서는 필수 아님 |
| `writePerformed` | MVP에서는 항상 `false`여야 함 |

시간값은 결정적 content 비교에서 제외하고 source·selection이 같으면 논리 preview가 같아야 한다.

## Adapter별 Preview

| Adapter | Preview target | 추가 진단 |
| --- | --- | --- |
| Codex | Project `AGENTS.md` | Global/project scope, skill 위치와 hook 충돌 |
| Claude | `CLAUDE.md` | Project/local settings, hooks/commands/skills mapping 상태 |
| Gemini | `GEMINI.md` | Workspace/user settings와 MCP/settings mapping 상태 |

Codex preview를 Claude/Gemini content로 재사용하지 않는다. 같은 resolved context를 각 adapter template에 독립 mapping한다.

## Preview 가능 상태

### Ready

- Blocking error와 unresolved required item이 없다.
- 필수 placeholder와 adapter target이 해소됐다.
- Validation checklist 필수 항목이 통과했다.

### Ready with Warnings

- Pending, output length, unsupported optional output 등 사용자가 이해하고 수용할 warning만 남았다.
- Warning source, 영향과 수동 후속 조치가 포함된다.

### Blocked

- Parse/path/duplicate ID, dependency, incompatible, missing bridge 또는 필수 adapter output 오류가 있다.
- Preview content는 완성 결과로 반환하지 않고 partial outline과 report만 제공할 수 있다.

## Length와 Placeholder 정책

- `docs/output-size-budget.md`의 output type별 line, heading과 estimated token 기준을 적용한다.
- Profile `output.size_budget`이 더 엄격한 값을 선언하면 profile 값을 적용하고 공통 error 기준을 함께 확인한다.
- 측정 결과, 적용 threshold와 severity를 validation report에 기록한다.
- 필수 규칙을 임의 절단하지 않는다.
- Skill body inline은 길이와 관계없이 error로 처리한다.
- 미치환 필수 placeholder는 error, 의도적 optional placeholder는 명시적 `해당 없음` 상태로 바꾼다.

## File Write 금지

- Output path는 계획 정보일 뿐 생성 대상 filesystem에 접근하지 않는다.
- Existing file overwrite, backup, permission과 Git operation을 수행하지 않는다.
- `writePerformed`는 MVP에서 항상 false다.
- Export와 installer는 별도 승인·설계 전까지 범위 밖이다.

## 현재 범위

Output serialization, download, CLI rendering, API response와 file writer는 구현하지 않는다.
