# registry

사용 가능한 stack, skill, profile, adapter와 template의 식별자 및 메타데이터를 관리할 영역입니다.

## Catalog 파일

| 파일 | 역할 |
| --- | --- |
| `fragments.yml` | Core, stack, bridge fragment의 경로, 의존·충돌과 merge 우선순위 |
| `skills.yml` | Common 및 stack-specific skill의 trigger, 추천 profile과 의존 관계 |
| `profiles.yml` | Profile manifest의 프로젝트 유형, 구성 개수와 adapter 대상 요약 |
| `adapters.yml` | Agent adapter 설계와 출력 template, 지원·미지원 범위 |
| `compatibility-matrix.yml` | Fragment 조합의 지원 관계, 필수 bridge와 pending 상태 |

현재 catalog는 실제 source와 관계를 사람이 검토하기 위한 YAML 초안입니다. Catalog를 읽는 자동 validator, generator와 installer는 아직 구현하지 않습니다. 필드 의미와 수동 검토 기준은 `docs/registry-catalog-guide.md`를 따릅니다.

## Core fragment

Global, project, quality core fragment도 출처, 상태와 조합 관계를 추적할 수 있도록 registry 관리 대상에 포함합니다. Core fragment는 모든 기술 조합의 공통 기반이며 stack 또는 bridge 항목으로 분류하지 않습니다.

현재는 `core/`의 문서 초안과 책임만 정의합니다. Core 항목을 담는 실제 catalog YAML이나 확정 schema는 아직 작성하지 않습니다.

## Stack catalog

Stack catalog는 language, framework, frontend, mobile, database, architecture, API와 bridge 구성 요소의 식별자, 상태, 버전과 의존 관계를 찾기 위한 목록입니다. 향후 각 항목이 제공하는 fragment와 필수·배타 조합을 참조할 수 있어야 합니다.

Java, Kotlin, Python, JavaScript와 Dart language fragment도 stack catalog의 관리 대상입니다. 각 항목은 source 경로, 상태, 지원 범위와 필요한 bridge 관계를 추적해야 하지만, 현재는 fragment 초안만 작성하며 실제 catalog YAML은 만들지 않습니다.

Spring framework, React frontend와 Flutter mobile fragment도 stack catalog의 관리 대상입니다. Language 항목과 구분되는 분류, 기반 language 및 database/API 조합에 필요한 bridge 관계를 추적해야 하지만, 실제 catalog YAML은 아직 만들지 않습니다.

RDB·NoSQL database, RESTful API와 Monolith·Modular Monolith·MSA·Clean Architecture·Hexagonal Architecture fragment도 stack catalog의 관리 대상입니다. 저장소 유형, 전송 계약, 배포 형태와 내부 의존성 style을 구분하고 함께 선택 가능한 항목 및 bridge 관계를 추적해야 하지만, 실제 catalog YAML은 아직 만들지 않습니다.

Bridge fragment도 필수 stack 조합, 적용 조건, 추가 의존, 충돌과 지원 상태를 추적하는 registry 관리 대상입니다. Bridge 등록은 구성 요소의 독립 지원과 구분하며, 현재는 7개 조합 fragment 초안만 작성하고 실제 catalog YAML과 compatibility matrix는 만들지 않습니다.

## Skill catalog

Skill catalog는 공통 및 stack-specific skill의 식별자, 사용 조건, 대상 stack과 수명 주기를 찾기 위한 목록입니다. Profile은 skill 본문을 복제하지 않고 이 catalog의 식별자를 참조합니다.

Common skill도 trigger, source 경로, 대상 agent, 상태와 다른 skill과의 의존·충돌을 추적하는 registry 관리 대상입니다. 현재는 8개 common `SKILL.md` 초안만 작성하고 실제 skill catalog YAML은 만들지 않습니다.

Backend, database, testing과 automation의 stack-specific skill도 적용 stack, trigger, common skill 의존, 대상 agent와 상태를 추적하는 registry 관리 대상입니다. 현재는 해당 영역의 8개 `SKILL.md` 초안만 작성하며 frontend/mobile skill과 실제 catalog YAML은 아직 만들지 않습니다.

Frontend와 Flutter mobile의 stack-specific skill도 UI/platform stack, API bridge, common skill 의존, 대상 agent와 상태를 추적하는 registry 관리 대상입니다. 현재는 두 영역의 8개 `SKILL.md` 초안만 작성하며 실제 catalog YAML과 library-specific metadata는 아직 만들지 않습니다.

## Profile catalog

Profile도 선택한 fragment·bridge·skill, variant, pending 책임과 대상 agent 상태를 추적하는 registry 관리 대상입니다. 현재 `profiles/*/profile.yml`은 registry ID가 확정되기 전의 저장소 상대 경로 기반 수동 검토용 초안이며, 실제 profile catalog YAML은 아직 만들지 않습니다.

## Adapter catalog

Codex, Claude와 Gemini adapter도 대상 agent, 입력 capability, 출력 종류, 미지원 기능과 의미 동등성 상태를 추적하는 registry 관리 대상입니다. 현재는 `adapters/*/adapter.md`와 placeholder template만 작성하며 실제 adapter catalog YAML과 변환 구현은 아직 만들지 않습니다.

## Compatibility matrix

`compatibility-matrix.yml`은 stack 간 조합, 필요한 bridge와 아직 bridge가 없는 pending 관계를 표현합니다. 지원 여부를 암묵적으로 추정하지 않고 조합 검증의 근거를 제공하는 것이 목적입니다.

## Metadata 규격

실제 catalog 파일을 작성하기 전까지 stack, skill, profile entry의 공통 metadata는 `templates/registry-entry.template.yml`을 기준으로 검토합니다. 이 템플릿은 식별자, 분류, source 경로, 의존·충돌 관계와 수명 주기 상태를 빠뜨리지 않기 위한 초안이며, 실제 registry 데이터나 확정된 schema는 아닙니다.

Profile 조합 초안은 `templates/profile.template.yml`을 따르며 상세 지침을 catalog entry나 profile에 복제하지 않습니다. 템플릿의 필드 의미와 사용 범위는 `docs/template-spec.md`에서 설명합니다.

## 현재 범위

현재는 fragment 26개, skill 24개, profile 6개, adapter 3개와 최소 compatibility 관계를 catalog YAML로 관리합니다. Schema validator, catalog 조회·병합 코드, generator, installer와 compatibility 자동 추론은 아직 작성하지 않습니다.
