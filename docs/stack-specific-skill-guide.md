# Stack-specific Skill 가이드

## 목적

Stack-specific skill은 특정 기술 영역의 책임, 데이터와 lifecycle을 알아야 수행할 수 있는 전문 workflow를 제공한다. 모든 프로젝트에 공통인 작업 순서를 반복하지 않고 backend, database, testing과 automation 영역에서 추가되는 판단과 검증만 정의한다.

현재 단계의 skill은 특정 제품이나 framework API에 고정되지 않은 영역별 초안이다. 실제 stack 선택과 프로젝트 설정을 읽어 필요한 세부 검증을 결정한다.

## Common Skill과의 차이

| 구분 | Common skill | Stack-specific skill |
| --- | --- | --- |
| 적용 범위 | 기술 조합과 무관한 반복 workflow | 특정 기술 영역의 경계와 위험이 있는 작업 |
| 예시 책임 | Debugging, test-first, review 순서 | Transaction, schema, query, backend layer 판단 |
| 입력 | 요청, diff, 일반 검증 기준 | 영역별 contract, 데이터, lifecycle과 운영 제약 |
| 조합 | 단독으로 사용할 수 있음 | 필요하면 common skill의 기본 흐름과 함께 사용 |

Stack-specific skill은 common skill을 복제하지 않는다. 예를 들어 query performance review는 access pattern과 index 판단을 추가하고, 일반적인 finding 작성 방식은 code-review에 맡긴다.

## 분류 기준

### Backend

Service layer, repository contract, transaction boundary와 RESTful API처럼 application 요청 처리 및 외부 경계를 조정하는 절차를 둔다. 특정 controller annotation, ORM과 language 구현은 포함하지 않는다.

### Database

Schema 변경, migration, query 비용, index와 data integrity처럼 저장 데이터의 안전성과 성능을 검토하는 절차를 둔다. 제품별 DDL, optimizer와 운영 명령은 product-specific skill로 분리한다.

### Testing

변경 책임에 맞는 test 수준과 검증 확대 순서를 선택하는 절차를 둔다. 특정 test runner와 mocking API는 stack-specific 하위 skill이 필요할 때 분리한다.

### Automation

Repository가 채택한 자동화의 side effect, 재실행과 실패 복구를 다루는 절차를 둔다. 현재는 git-auto hook workflow만 포함하며 hook 구현이나 installer는 만들지 않는다.

Frontend와 mobile의 component, rendering, navigation, platform 연동 skill은 별도 `frontend-mobile-skill-guide.md`와 각 `SKILL.md`에서 관리한다. Backend workflow를 해당 영역에 그대로 재사용한다고 가정하지 않는다.

## Profile Manifest 선택 기준

1. Profile이 포함하는 stack과 반복 작업 유형을 식별한다.
2. 모든 stack에 필요한 workflow면 common skill을 선택하고, 영역 지식이 필요한 절차만 stack-specific skill로 추가한다.
3. Skill의 `description`, 필요한 입력과 적용 제외 조건이 profile 목적에 맞는지 확인한다.
4. 같은 책임을 가진 skill을 중복 선택하지 않고 common–stack-specific 간 의존과 실행 순서를 명시한다.
5. 대상 agent 지원, context 비용, project의 실제 검증 도구와 자동화 정책을 검토한다.

Profile은 skill 본문을 복제하지 않고 registry 식별자만 참조한다. Profile에 stack이 있다는 이유만으로 해당 분류의 모든 skill을 포함하지 않으며 실제 작업과 품질 gate에 필요한 최소 집합을 선택한다.

## 작성 및 검증 기준

- 각 skill은 trigger를 포함한 frontmatter와 필수 8개 section을 가진다.
- 영역별 판단 절차와 검증만 포함하고 common workflow 및 fragment 상시 규칙을 반복하지 않는다.
- 특정 제품·framework 구현은 별도 product-specific skill 또는 reference로 분리한다.
- Skill은 사용자와 저장소의 권한을 넓히지 않고 실행하지 않은 검증을 성공으로 처리하지 않는다.
- Script, asset와 agent별 metadata는 필요성이 확정되기 전까지 추가하지 않는다.

## 현재 범위

현재 backend 4종, database 2종, testing 1종과 automation 1종의 `SKILL.md`가 존재하고 frontend/mobile skill 8종도 별도로 존재한다. Profile YAML과 skill catalog가 이 자산을 참조하며 product-specific skill과 실행 구현은 현재 범위에 포함하지 않는다.
