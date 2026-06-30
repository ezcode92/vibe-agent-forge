# Profile Manifest 가이드

## 목적

Profile manifest는 특정 개발환경에 필요한 core, stack, bridge fragment와 reusable skill을 하나의 검토 가능한 조합으로 선언한다. Profile은 지침 본문이나 프로젝트 설정을 복제하지 않고 어떤 source를 왜 함께 선택하는지와 조합 제약을 표현한다.

현재 registry catalog는 존재하지만 generator와 schema validator는 없다. `profile.yml`은 저장소 상대 경로를 참조하는 수동 검토용 초안이며 catalog ID와 path를 사람이 대조한다. ID 참조 전환 시점은 generator 구현 전 결정사항으로 남긴다.

## Manifest 구조

| 필드 | 역할 |
| --- | --- |
| `id`, `name`, `description` | Profile의 안정된 식별자와 조합 목적 |
| `target_agents`, `adapters` | 대상 agent와 adapter 참조. 구현 전에는 빈 목록으로 유지 |
| `base_fragments` | Global 및 project core fragment |
| `quality_rules` | 공통 quality fragment |
| `stacks` | 필수 language, framework/platform, database, API와 architecture fragment |
| `bridges` | 필수 stack 조합 사이의 연결 fragment |
| `skills` | Profile에서 선택 가능한 common 및 stack-specific skill |
| `variants` | 반드시 선택해야 하는 대체 fragment·bridge 묶음 |
| `output` | 논리적 출력 대상, 필수 section과 크기 정책 |
| `constraints` | 필수·배타 조합, pending과 수동 검토 주의사항 |

목록 순서는 merge priority를 대신하지 않는다. 최종 조합 순서와 충돌 처리는 `docs/merge-policy.md`를 따른다.

## Fragment와 Skill 연결 방식

Profile은 먼저 core와 독립 stack을 선택하고, 둘 이상의 stack 사이에만 필요한 bridge를 추가한다. Skill은 profile의 실제 반복 작업과 품질 gate에 필요한 최소 집합만 참조하며 fragment의 상시 규칙이나 skill 본문을 manifest에 복제하지 않는다.

현재 경로 참조는 다음 원칙을 따른다.

- Fragment는 repository root 기준 `agents.fragment.md` 경로를 사용한다.
- Skill은 repository root 기준 `SKILL.md` 경로를 사용한다.
- 필수 참조는 실제 파일이 존재해야 한다.
- Adapter 구현 전에는 존재하지 않는 adapter를 경로로 참조하지 않는다.

## 선택형 Fragment 표현

둘 이상의 대안 중 하나가 반드시 필요한 경우 `variants`에 이름 있는 선택 축을 선언한다. 각 선택 축은 `selection: "exactly-one"`, `required: true`와 `options`를 가지며 option마다 함께 선택할 fragment와 bridge를 묶는다.

예를 들어 fullstack Spring profile의 backend language는 Java와 Kotlin 중 정확히 하나를 선택하고 대응하는 language–Spring bridge를 같은 option에 둔다. 선택 전 profile은 완성된 최종 조합이 아니며, generator가 없으므로 수동 검토자가 선택 결과와 배타 조건을 확인한다.

## Pending Fragment 표현

필요한 책임의 fragment가 아직 없으면 존재하지 않는 경로를 `stacks`에 넣지 않는다. 대신 `constraints.pending`에 안정된 `id`, `status`와 `reason`을 기록한다.

`status`는 현재 초안에서 `<영역> fragment pending` 형식을 사용한다. Pending은 지원 완료를 의미하지 않으며 존재 경로 검증에서 제외한다. 해당 fragment가 추가되면 pending을 제거하고 필수 참조 및 필요한 bridge 검증을 수행한다.

## Profile 검증 기준

- 모든 `profile.yml`이 YAML로 파싱되고 root가 mapping이다.
- `id`가 디렉터리 이름과 일치하고 profile 간 중복되지 않는다.
- `base_fragments`, `quality_rules`, `stacks`, `bridges`, `skills`의 모든 경로가 실제 파일을 가리킨다.
- Variant option과 pending 항목은 필수 참조 경로 존재 검증에서 제외하고 선택 조건, 이유와 해소 조건을 수동 검토한다.
- 필수 stack에 대응하는 bridge가 누락되지 않고 배타 option이 동시에 선택되지 않는다.
- 동일 참조가 여러 section이나 list에 중복되지 않는다.
- `target_agents`와 `adapters`가 비어 있으면 agent별 생성이 아직 지원되지 않는 초안으로 판단한다.

## 수동 검토 범위

현재는 schema validator, dependency resolver, merge engine과 generator가 없다. 따라서 profile은 다음 사항을 사람이 검토하기 위한 설계 문서다.

- 선택 조합이 프로젝트 목적과 맞는지
- Fragment와 skill 경로가 존재하고 책임이 중복되지 않는지
- Bridge와 variant가 필요한 조합을 완전하게 표현하는지
- Pending 책임이 지원 완료로 오해되지 않는지
- Output section과 context 크기 정책이 합리적인지

Profile manifest를 근거로 실제 `AGENTS.md`, agent 설정, source code 또는 설치 산출물을 자동 생성하지 않는다.

## 현재 범위

현재 6개 profile manifest, profile catalog, compatibility matrix와 adapter 설계가 존재한다. 이 문서는 수동 검토 규칙을 정의하며 generator, adapter 실행 기능, installer와 Web UI는 구현하지 않는다.
