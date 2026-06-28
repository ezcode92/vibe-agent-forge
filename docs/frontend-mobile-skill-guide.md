# Frontend 및 Mobile Skill 가이드

## 목적

Frontend/mobile skill은 사용자 interface, 상태, 비동기 API, navigation과 platform lifecycle을 알아야 수행할 수 있는 전문 workflow를 제공한다. Fragment의 상시 규칙과 common skill의 일반 절차를 반복하지 않고 화면·app 경계에서 추가되는 판단과 검증만 정의한다.

현재 frontend 범위는 component, state, API client와 UI 오류이며 mobile 범위는 Flutter screen, state, API와 build/debug다. 특정 상태관리·HTTP·logging library의 API는 포함하지 않는다.

## Common Skill과의 차이

Common skill은 debugging, incremental implementation과 security review처럼 stack과 무관한 작업 순서를 제공한다. Frontend/mobile skill은 component tree, UI state, network lifecycle, navigation, rebuild와 platform target 같은 영역별 판단을 추가한다.

두 종류가 모두 필요하면 common skill을 기본 workflow로 사용하고 frontend/mobile skill에서 해당 UI·platform 경계만 구체화한다. 예를 들어 Flutter build 실패에는 common debugging의 재현·가설 절차와 Flutter build-debug의 flavor·target 분류를 함께 적용할 수 있다.

## Frontend Skill과 Mobile Skill의 경계

| 구분 | Frontend skill | Mobile skill |
| --- | --- | --- |
| UI 구조 | Component, props와 web interaction | Flutter widget, screen과 navigation |
| State | Local/global/server/cache 소유권 | Widget/app state, Future·Stream과 lifecycle |
| API | Browser/client session과 backend contract | Mobile network, offline, token과 app version |
| 오류·품질 | UI message, retry와 접근성 | App lifecycle, platform target와 offline 복구 |

공통 개념이 있어도 구현 lifecycle이 다르면 한 skill로 합치지 않는다. UI error taxonomy처럼 양쪽에서 재사용 가능한 절차는 frontend skill을 참조할 수 있지만 Flutter 고유 lifecycle은 mobile skill이 소유한다.

## API Bridge와의 관계

API bridge fragment는 client와 server가 공유해야 할 contract, error schema, 인증과 version 연결 규칙을 정의한다. API integration skill은 해당 규칙과 실제 project contract를 입력으로 받아 DTO/model mapping, state 전환과 검증을 수행한다.

Bridge가 선택되지 않았거나 contract가 불명확하면 skill이 임의의 wire format을 만들지 않는다. `react-spring-api`, `flutter-rest-api` 등 profile에 선택된 bridge를 확인하고, backend 조합에 종속되지 않은 frontend client에는 해당 API fragment와 contract만 적용한다.

## Profile Manifest 선택 기준

1. Profile의 UI stack, platform, API 조합과 반복 작업을 식별한다.
2. Component/screen 구현, state review, API integration, UI error 또는 build-debug 중 실제 필요한 workflow만 선택한다.
3. Common skill과 책임이 겹치면 stack-specific skill이 추가하는 경계가 있는지 확인한다.
4. API integration에는 호환되는 API bridge 또는 contract source가 있는지 검증한다.
5. 대상 agent 지원, context 비용, project test/build 환경과 library 비종속성을 확인한다.

Profile은 모든 frontend/mobile skill을 기본 포함하지 않고 품질 gate와 작업 유형에 필요한 최소 식별자만 참조한다. Skill 본문과 library 설정을 profile에 복제하지 않는다.

## 작성 및 검증 기준

- 각 skill은 trigger frontmatter와 필수 8개 section을 가진다.
- Workflow와 검증을 중심으로 작성하고 UI 코드, build script와 package 설정을 포함하지 않는다.
- Library 또는 제품 API가 필요하면 별도 product-specific skill/reference로 분리한다.
- Fragment와 bridge의 상시 규칙을 반복하지 않고 선택된 조합을 입력으로 사용한다.
- 실행하지 않은 platform, 접근성과 lifecycle 검증을 성공으로 처리하지 않는다.

## 현재 범위

현재는 frontend 4종과 Flutter mobile 4종의 `SKILL.md` 초안만 정의한다. 실제 profile YAML, skill catalog, library-specific skill, UI 코드, build script와 installer는 만들지 않는다.
