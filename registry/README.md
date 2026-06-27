# registry

사용 가능한 stack, skill, profile, adapter와 template의 식별자 및 메타데이터를 관리할 영역입니다.

## Stack catalog

Stack catalog는 language, framework, frontend, mobile, database, architecture, API와 bridge 구성 요소의 식별자, 상태, 버전과 의존 관계를 찾기 위한 목록입니다. 향후 각 항목이 제공하는 fragment와 필수·배타 조합을 참조할 수 있어야 합니다.

## Skill catalog

Skill catalog는 공통 및 stack-specific skill의 식별자, 사용 조건, 대상 stack과 수명 주기를 찾기 위한 목록입니다. Profile은 skill 본문을 복제하지 않고 이 catalog의 식별자를 참조합니다.

## Compatibility matrix

Compatibility matrix는 stack 간 조합, profile과 adapter 지원 범위, 필요한 bridge와 알려진 비호환 조건을 표현합니다. 지원 여부를 암묵적으로 추정하지 않고 조합 검증의 근거를 제공하는 것이 목적입니다.

## 현재 범위

Phase 1에서는 위 catalog의 책임과 관계만 설명합니다. 실제 registry 데이터, schema, compatibility 파일과 조회 코드는 아직 작성하지 않습니다.
