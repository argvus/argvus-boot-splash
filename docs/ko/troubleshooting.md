---
title: 문제 해결
description: 일반적인 부트 스플래시 증상과 해결 방법.
---

# 문제 해결

**설치 후 스플래시 화면이 변경되지 않았습니다.**
initramfs가 재생성되지 않았습니다. `sudo mkinitcpio -P`(또는 `sudo dracut --regenerate-all`)를 실행하고 재부팅하십시오. 시스템이 여러 커널을 사용하는 경우, 부팅한 커널이 새로운 initramfs를 사용하고 있는지 확인하십시오.

**스플래시 화면이 전혀 없고 화면이 검정색이거나 텍스트만 표시됩니다.**
`plymouth`가 initramfs 훅에서 누락되었습니다. `/etc/mkinitcpio.conf`를 확인하고 `HOOKS=(...)`가 `plymouth`를 포함하고 있는지 확인한 후 다시 빌드하고 재부팅하십시오. Ubuntu/Debian에서는 `plymouth`와 `plymouth-x11`/`plymouth-themes`가 설치되었는지, `GRUB_CMDLINE_LINUX`가 `splash quiet`를 포함하고 있는지도 확인하십시오.

**로고만 표시되고 진행 상황은 없음.**
일부 부팅 단계가 init에 의해 보고되지 않거나 진행 상황 콜백이 호출되지 않을 수 있습니다. 이는 시스템 쪽에서 문제가 있는 것이 아닙니다. 진행 바는 Plymouth가 보고한 진행 상황을 기준으로 채워지며, 일부 환경(예: systemd의 `plymouth-spawn` 없는 시퀀스 또는 특정 dracut 모듈 사용 시)에서는 이 정보가 제공되지 않을 수 있습니다.

**암호 입력창이 잘못 위치하거나 보이지 않습니다.**  
대화 상자는 워드마크와 트랙 기하학을 기준으로 위치가 정해지므로, 극단적인 해상도(매우 작은 텍스트 모드)에서는 화면 밖으로 밀려날 수 있습니다. 일반 해상도를 사용하고, 일반적인 해상도에서도 발생하면 보고하세요.  

**Plymouth가 조기에 종료되거나 텍스트 콘솔이 보입니다.**  
Plymouth를 비활성화한 무언가가 있습니다: `quiet` 부팅 매개변수가 `splash` 없이 설정되었거나, `plymouth` 훅이 제거되었거나, Plymouth가 사용할 수 없는 드라이버가 있습니다. Plymouth는 시스템을 멈추지 않고 텍스트 콘솔로 종료됩니다 — 이는 정상적인 동작입니다.  

**`argvus-plymouth`에서 업그레이드한 후 테마가 적용되지 않습니다.**  
새 패키지가 기존 패키지를 대체합니다; `/etc/plymouth/plymouthd.conf`가 `PLYMOUTH_THEME_NAME=argvus`를 표시하는지 확인하고 initramfs를 재빌드하세요.  

**서명 확인 중 설치 실패.**  
저장소 키가 키링에 없거나 오래되었습니다. 현재 공개 키를 다시 가져온 후, `sudo pacman -Sy`를 실행하세요.

**잠금 화면 / 절전 모드에는 변화가 없습니다.**  
테마는 부팅 화면에만 적용됩니다. 최대 절전 / 복원 화면은 별도로 제어됩니다  
(`systemd-homed`, 화면 잠금기, initramfs의 절전 타겟에서 `plymouth` 사용).

**미리보기 후에도 Plymouth가 여전히 실행 중입니다.**  
`sudo plymouthquit`가 세션을 복원합니다. 화면이 검게 유지되면 다른 가상 터미널로 전환하세요 (`Ctrl+Alt+F2`) — 세션은 그대로 유지됩니다.

## 다음 단계

- [설치 ](/docs/argvus-boot-splash/installation/) — 다른 방법으로 재시도하세요.  
- [사용법 ](/docs/argvus-boot-splash/usage/) — 명령어 치트 시트.
