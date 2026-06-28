# registry

사용 가능한 stack, skill, profile, adapter와 template의 식별자 및 메타데이터를 관리할 영역입니다.

## Core fragment

Global, project, quality core fragment도 출처, 상태와 조합 관계를 추적할 수 있도록 registry 관리 대상에 포함합니다. Core fragment는 모든 기술 조합의 공통 기반이며 stack 또는 bridge 항목으로 분류하지 않습니다.

현재는 `core/`의 문서 초안과 책임만 정의합니다. Core 항목을 담는 실제 catalog YAML이나 확정 schema는 아직 작성하지 않습니다.

## Stack catalog

Stack catalog는 language, framework, frontend, mobile, database, architecture, API와 bridge 구성 요소의 식별자, 상태, 버전과 의존 관계를 찾기 위한 목록입니다. 향후 각 항목이 제공하는 fragment와 필수·배타 조합을 참조할 수 있어야 합니다.

## Skill catalog

Skill catalog는 공통 및 stack-specific skill의 식별자, 사용 조건, 대상 stack과 수명 주기를 찾기 위한 목록입니다. Profile은 skill 본문을 복제하지 않고 이 catalog의 식별자를 참조합니다.

## Compatibility matrix

Compatibility matrix는 stack 간 조합, profile과 adapter 지원 범위, 필요한 bridge와 알려진 비호환 조건을 표현합니다. 지원 여부를 암묵적으로 추정하지 않고 조합 검증의 근거를 제공하는 것이 목적입니다.

## Metadata 규격

실제 catalog 파일을 작성하기 전까지 stack, skill, profile entry의 공통 metadata는 `templates/registry-entry.template.yml`을 기준으로 검토합니다. 이 템플릿은 식별자, 분류, source 경로, 의존·충돌 관계와 수명 주기 상태를 빠뜨리지 않기 위한 초안이며, 실제 registry 데이터나 확정된 schema는 아닙니다.

Profile 조합 초안은 `templates/profile.template.yml`을 따르며 상세 지침을 catalog entry나 profile에 복제하지 않습니다. 템플릿의 필드 의미와 사용 범위는 `docs/template-spec.md`에서 설명합니다.

## 현재 범위

Phase 1에서는 위 catalog의 책임과 template 기반 metadata 구조만 설명합니다. 실제 registry 데이터, 확정 schema, compatibility matrix와 조회 코드는 아직 작성하지 않습니다.
