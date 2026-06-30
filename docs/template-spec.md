# Template 명세

## 목적

`templates/`는 VibeAgentForge가 관리할 생성 단위의 표준 구조를 정의한다. 템플릿은 실제 생성 결과가 아니라 작성자가 책임, 입력, 검증과 참조 관계를 빠뜨리지 않도록 하는 문서 자산이다. Codex template은 `mvp-contract`와 호환되며 Claude/Gemini template은 adapter와 함께 `draft`로 유지한다.

템플릿의 `<...>` 표시는 실제 자산을 작성하는 단계에서 문맥에 맞는 값으로 교체한다. 설명용 주석과 안내 문장은 결과 자산에 필요하지 않으면 제거한다. 템플릿을 복사했다는 이유만으로 registry 등록이나 지원 상태가 확정되지는 않는다.

## 생성 단위별 표준

| 템플릿 | 표준화 대상 | 역할 |
| --- | --- | --- |
| `templates/agents-fragment.template.md` | stack fragment | 하나의 stack에 고유한 규칙, 패턴, 검증과 bridge 분리 조건을 정의한다. |
| `templates/skill.template.md` | 에이전트 중립 skill 문서 | 조건부 전문 작업의 입력, 절차, 검증과 완료 기준을 정의한다. |
| `templates/profile.template.yml` | profile manifest | stack, bridge, quality rule, skill과 adapter의 조합 및 출력 제약을 선언한다. |
| `templates/adapter.template.md` | adapter 계약 | 중립 source를 대상 agent 형식으로 변환할 때의 책임과 기능 차이를 정의한다. |
| `templates/registry-entry.template.yml` | stack·skill·profile catalog entry | 구성 요소를 조회하고 관계를 검증하기 위한 공통 metadata를 정의한다. |

## 사용 방식

1. 만들려는 자산의 책임이 stack fragment, skill, profile, adapter 또는 registry entry 중 어디에 속하는지 먼저 결정한다.
2. 해당 템플릿을 기준으로 placeholder를 채우되 기존 `docs/` 명세와 registry 식별자를 참조한다.
3. stack 간에만 유효한 규칙은 개별 stack fragment에 넣지 않고 bridge 필요 조건으로 표시한다.
4. profile에는 지침 본문을 복제하지 않고 registry 식별자와 조합 제약만 선언한다.
5. adapter는 정책을 새로 정의하지 않고 대상 agent의 표현 방식과 미지원 기능만 다룬다.
6. 작성 결과는 구조, 참조 무결성, 충돌, 검증 가능성과 대상 agent의 의미 보존 여부를 검토한다.

YAML 템플릿의 placeholder는 문자열로 인용되어 있어 구조를 읽을 수 있다. 실제 항목에 해당 값이 없다면 placeholder를 남기지 말고 빈 목록 또는 합의된 생략 규칙을 사용한다. Catalog YAML은 존재하지만 자동 schema validation 방식은 아직 결정하지 않았다.

## 기존 명세와의 관계

- Fragment의 조합과 우선순위는 `docs/merge-policy.md`를 따른다.
- Profile의 역할과 조합 검증은 `docs/profile-spec.md`를 따른다.
- Skill의 책임과 에이전트 권한 경계는 `docs/skill-spec.md`를 따른다.
- Stack 분류와 책임은 `docs/stack-catalog.md`를 따른다.
- 전역 설정과 프로젝트 설정은 fragment나 profile에 흡수하지 않고 기존 경계를 유지한다.

문서 간 충돌이 발견되면 템플릿만으로 새 정책을 확정하지 않고 관련 설계 문서를 함께 검토한다.

## 현재 구현하지 않는 범위

이 단계에서는 다음 항목을 만들거나 확정하지 않는다.

- 실제 기술별 stack·bridge fragment
- 실제 `SKILL.md`와 에이전트별 skill 패키지
- 실제 profile YAML과 registry catalog 데이터
- compatibility matrix와 자동 호환성 판정 규칙
- schema validator, generator, installer와 변환 adapter 코드
- Codex, Claude Code, Gemini CLI용 실제 생성 결과
- Web UI, 관리 API, 배포와 원격 동기화 기능
