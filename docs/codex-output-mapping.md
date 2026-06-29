# Codex Output Mapping

## 목적

Resolved profile과 project metadata를 Codex `AGENTS.preview.md`의 8개 section에 배치하는 규칙을 정의한다. 이 문서는 content mapping 계약이며 Markdown renderer나 생성 로직을 정의하지 않는다.

## 공통 규칙

- Template의 section 순서와 heading을 유지한다.
- 같은 source 집합과 project metadata는 같은 논리 section 결과를 만든다.
- Source 의미와 provenance를 보존하되 전문 복사가 아니라 상시 필요한 규칙만 요약한다.
- 미선택 fragment, skill과 추정 기술은 추가하지 않는다.
- 필수값은 미치환 placeholder로 남기지 않는다.
- Project별 비필수 값이 확인되지 않으면 사실처럼 채우지 않고 `확인 필요`, 적용되지 않으면 `해당 없음`으로 표시한다.

## Section별 Mapping

| Section | Profile metadata | Fragment/skill mapping | Project metadata |
| --- | --- | --- | --- |
| Project Overview | `name`, `description` | Core project fragment의 목적·단계 경계 | 실제 목적, 사용자, 현재 단계, 허용 작업 |
| Tech Stack | `stacks`, `bridges`, 해소된 variant | Fragment category와 bridge 관계의 짧은 이름 | 실제 version·제품은 확인된 경우만 추가 |
| Included Fragments | `base_fragments`, `stacks`, `bridges`, `quality_rules` | Category, ID 또는 path와 선택 근거 | 없음 |
| Included Skills | `skills` | Skill ID, 짧은 역할·trigger, path, lazy-load 조건 | Team별 사용 조건이 확인되면 추가 |
| Working Rules | 선택 구성과 constraint | Core → stack → bridge의 resolved 상시 규칙 | Repository architecture와 작업 방식 |
| Validation Commands | `output.required_sections`의 검증 요구 | Quality/stack fragment의 검증 종류 | 확인된 build, test, lint/format, 추가 명령 |
| Done Definition | Output 요구와 constraint | Core project·quality의 완료·보고 원칙 | Project별 완료와 문서 갱신 조건 |
| Scope Boundary | `constraints.requires`, `excludes`, `pending` | Adapter·fragment 적용 경계 | Allowed, excluded, automation과 preview 제한 |

## Profile Metadata 규칙

- `id`는 preview provenance에 사용하고 project 표시 이름으로 자동 대체하지 않는다.
- `name`과 `description`은 `Project Overview`의 기본 문맥이다.
- `stacks`와 `bridges`는 registry metadata를 통해 사람이 읽을 수 있는 `Tech Stack` 항목으로 표현한다.
- `base_fragments`, `quality_rules`는 `Included Fragments`에서 별도 category로 유지한다.
- `constraints.requires`, `excludes`, `pending`은 작업 규칙으로 섞지 않고 주로 `Scope Boundary`에 둔다.
- `output.required_sections`는 section completeness 검증 기준이며 그대로 본문에 복사하지 않는다.
- `output.size_budget`은 validation report에 기록하고 preview section content로 삽입하지 않는다.

## Fragment Summary 규칙

- 모든 선택 fragment는 `Included Fragments`에서 category와 source를 한 번 이상 추적할 수 있어야 한다.
- Fragment의 상시 적용 규칙은 `Working Rules`의 관련 책임 하위에 요약한다.
- Bridge는 두 stack 사이에서만 발생하는 교차 책임으로 분리한다.
- 같은 의미의 core·stack·bridge 규칙은 한 번만 표현하고 merge trace에 모든 provenance를 남긴다.
- Fragment 전문, 긴 배경, 예시와 checklist를 `AGENTS.preview.md`에 삽입하지 않는다.
- 요약 때문에 보안, scope 또는 required validation 의미가 사라지면 preview를 차단한다.

## Skill Reference 규칙

- Profile이 선택한 skill만 `Included Skills`에 포함한다.
- Skill ID, 짧은 목적 또는 trigger, source reference와 lazy-load 조건만 허용한다.
- Skill 선택 근거와 dependency 상세는 skill selection report에 둔다.
- `SKILL.md` 본문, 절차, checklist와 예시는 inline하지 않는다.
- Skill path가 없거나 required dependency가 해소되지 않으면 reference를 추정하지 않고 error로 처리한다.

## Validation Command Placeholder 정책

- 실제 project metadata에서 확인된 명령만 실행 가능한 명령으로 표시한다.
- Profile이 validation section을 요구하지만 명령이 제공되지 않은 manual preview는 `<실제 프로젝트 build 명령 확인 필요>`처럼 명시적 확인 필요 값으로 치환할 수 있다.
- 명시적 확인 필요 값은 template placeholder가 아니라 알려진 metadata 공백의 표시이며, 실제 실행·성공을 의미하지 않는다.
- Adapter가 stack 관례를 근거로 명령을 발명하지 않는다.
- 실제 적용 또는 export를 전제로 하는 profile에서 필수 명령이 없으면 warning 또는 profile constraint에 따라 error로 처리한다.
- 적용할 명령이 없는 항목은 근거가 있을 때만 `해당 없음`으로 표시한다.

## Git-auto Hook 문구 Mapping

- Git-auto 사용 여부와 작업 책임은 `Scope Boundary`의 `Automation` 항목에 둔다.
- 허용 문구는 직접 commit·push 금지, Stop hook 책임, `.gitauto/` staging 제외와 기존 `.codex/hooks` 보호 정책의 요약이다.
- Hook event, script 본문, `.codex/hooks.json` 내용, secret과 외부 서비스 식별자는 넣지 않는다.
- Git-auto 정책을 `Working Rules`에 반복하지 않는다. 작업 중 항상 필요한 한 문장이 있더라도 최종 provenance는 `Scope Boundary`에 둔다.

## 금지 Mapping

- Fragment 전문의 연속 삽입
- 선택된 모든 skill 본문의 inline
- Global `AGENTS.md` content 생성
- Hook/settings content 생성
- 미지원 feature의 조용한 삭제
- 미확정 project metadata의 자동 추정

금지 mapping이 발견되면 `docs/codex-adapter-validation.md`에 따라 severity를 결정한다.

