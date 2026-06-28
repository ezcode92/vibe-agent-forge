# Skill 선택 전략

## 목적

Profile 기본 skill과 작업 유형별 optional skill을 구분하고 필요한 절차만 lazy loading하도록 선택 기준을 정의한다. Skill을 agent 상시 지침에 모두 삽입하지 않고 context와 책임 중복을 제한하는 것이 목적이다.

## 입력 Source

- Profile manifest의 `skills` 목록
- `registry/skills.yml`의 category, trigger, 추천 profile, dependency와 conflict
- Selected profile ID와 stack 구성
- 현재 작업 유형과 사용자 명시 선택
- Target adapter의 skill 지원 및 unsupported output

## Profile 기본 Skill

- Manifest `skills`에 있는 항목을 profile 기본 후보로 해석한다.
- 기본 후보는 설치·자동 실행을 뜻하지 않고 해당 profile에서 사용할 수 있는 검토 집합이다.
- Path를 skill catalog ID에 mapping하고 count 및 dependency를 확인한다.
- Profile 목적과 무관한 추천 skill을 catalog 전체에서 자동 추가하지 않는다.

## 작업 유형별 Optional Skill

- User 요청과 skill `description`의 trigger 의미를 먼저 비교한다.
- `trigger_keywords`는 검색·추천 보조로만 사용하고 단독 자동 선택 근거로 사용하지 않는다.
- 현재 profile의 stack, category와 adapter 지원 범위가 맞는지 확인한다.
- Optional skill을 선택하면 hard dependency와 conflict를 다시 검증한다.
- 추천 수락·거절과 이유를 preview metadata에 남긴다.

## 항상 Load하지 않는 Skill 기준

- 특정 작업에서만 필요한 debugging, review, migration과 build 절차
- 현재 profile에 포함됐지만 이번 요청과 trigger가 맞지 않는 skill
- Target adapter가 호출·참조 방식을 지원하지 않는 skill
- Pending 또는 dependency가 해결되지 않은 skill
- 다른 skill과 동일 책임을 반복해 context만 늘리는 skill
- Secret, 환경별 설정 또는 미확인 product 지식이 필요한 skill

상시 적용해야 하는 프로젝트 정책은 skill이 아니라 core/project 또는 fragment에 둔다.

## Common과 Stack-specific 우선순위

1. Common skill이 작업의 기본 workflow와 안전한 검증 순서를 제공한다.
2. Stack-specific skill이 해당 domain의 추가 입력, 경계와 판단을 구체화한다.
3. 두 skill이 같은 절차를 반복하면 common 흐름을 한 번만 유지하고 stack 차이만 추가한다.
4. Stack-specific skill이 common skill의 권한·금지 범위를 넓히지 않는다.
5. Dependency가 명시된 경우 common skill을 먼저 resolve하되 실제 본문 load는 현재 단계에 필요한 부분만 수행한다.

Priority는 한 skill이 다른 skill을 override한다는 뜻이 아니라 workflow 조합 순서를 뜻한다.

## Trigger Keyword 사용 방식

- Keyword를 정규화해 사용자 요청과 category 검색 후보를 좁힌다.
- Exact match가 없어도 skill description과 작업 목적이 명확하면 후보가 될 수 있다.
- 여러 skill이 match하면 responsibility, profile 포함 여부와 dependency를 비교한다.
- Keyword만 맞고 사용 조건이 다르면 선택하지 않는다.
- 최종 선택 근거에는 matched keyword보다 작업 목적과 필요한 결과를 기록한다.

## Lazy Loading 원칙

- Catalog metadata와 `SKILL.md` frontmatter는 선택 전 discovery 정보로 사용한다.
- 본문은 skill이 명시 선택되거나 trigger가 확인된 뒤에만 load한다.
- 여러 skill을 선택하면 현재 단계에 필요한 순서대로 load하고 무관한 reference는 읽지 않는다.
- Skill 본문을 preview `AGENTS.md`/`CLAUDE.md`/`GEMINI.md`에 통째로 복제하지 않는다.
- Adapter가 별도 skill 구조를 지원하지 않으면 상시 지침으로 자동 확장하지 않고 unsupported/manual mapping으로 보고한다.

## Token 절약 기준

- Profile 기본 skill 전체가 아니라 선택 skill ID, trigger와 짧은 진입 규칙만 preview에 표시한다.
- 중복 workflow는 source reference 하나로 합친다.
- 상세 예시, product variant와 긴 checklist는 필요할 때만 reference로 읽는다.
- Token 비용 때문에 필수 안전 절차를 삭제하지 않으며 budget 초과는 warning으로 보고한다.

## 검증 기준

- 선택 skill이 profile 또는 명시 optional 입력에 존재한다.
- Trigger와 현재 작업 목적이 연결된다.
- Hard dependency와 conflict가 해결된다.
- Common/stack-specific 책임이 중복되지 않는다.
- Adapter 미지원과 lazy loading 제한이 report에 반영된다.

## 현재 범위

Skill recommendation engine, keyword matcher와 token estimator는 구현하지 않는다. 현재 전략은 수동 선택과 향후 generator의 검증 계약만 정의한다.
