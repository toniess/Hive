<div align="center">

<img src="images/bee.svg" width="120" alt="Hive logo"/>

# Hive

**Настольная стратегия «Улей» — шахматы без доски, где фигуры — насекомые.**

[![Build](https://github.com/toniess/Hive/actions/workflows/build.yml/badge.svg)](https://github.com/toniess/Hive/actions/workflows/build.yml)
[![Release](https://img.shields.io/github/v/release/toniess/Hive?include_prereleases&label=release)](https://github.com/toniess/Hive/releases)
![Qt](https://img.shields.io/badge/Qt-6-41CD52?logo=qt&logoColor=white)
![QML](https://img.shields.io/badge/UI-QML-41CD52)
![Platforms](https://img.shields.io/badge/platforms-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)

[Скачать](#-скачать) · [Как играть](#-как-играть) · [Сборка из исходников](#-сборка-из-исходников)

</div>

---

## 🐝 Об игре

**Hive** — абстрактная настольная игра для двоих. Доски нет: поле складывается из шестиугольных фишек прямо по ходу партии. Цель — окружить пчелиную матку соперника со всех шести сторон раньше, чем он окружит вашу.

Этот проект — компьютерная версия игры на **Qt Quick / QML**: аккуратный код, анимации и ничего лишнего.

## 🐜 Фигуры

У каждого игрока одинаковый набор фишек (базовая игра и дополнения):

| | Фигура | Кол-во | Как ходит |
|:-:|---|:-:|---|
| <img src="images/bee.svg" width="36"/> | **Пчелиная матка** | 1 | На одну клетку. Должна быть выставлена не позже 4-го хода |
| <img src="images/ant.svg" width="36"/> | **Муравей** | 3 | На любое свободное место по периметру улья |
| <img src="images/grasshoper.svg" width="36"/> | **Кузнечик** | 3 | Прыгает по прямой через ряд фишек на первую свободную клетку |
| <img src="images/bug.svg" width="36"/> | **Жук** | 2 | На одну клетку, может забираться на других насекомых |
| <img src="images/spider.svg" width="36"/> | **Паук** | 2 | Ровно на три клетки по периметру улья |
| <img src="images/gnat.svg" width="36"/> | **Комар** | 1 | Копирует ход соседнего насекомого |
| <img src="images/ladybug.svg" width="36"/> | **Божья коровка** | 1 | Два шага по верху улья и один шаг вниз |
| <img src="images/pillbug.svg" width="36"/> | **Мокрица** | 1 | На одну клетку; может переносить соседнюю фишку |

## 🎮 Как играть

1. Игроки ходят по очереди — белые слева, чёрные справа. Панель игрока, чей сейчас не ход, затемняется.
2. Чтобы **выставить** фигуру, кликните по ней на своей панели, затем по свободному шестиугольнику на поле.
3. Чтобы **переместить** фигуру, кликните по ней на поле, затем по клетке назначения. Повторный клик отменяет выбор.
4. Улей всегда должен оставаться единым — нельзя делать ход, который разрывает его на части.
5. Побеждает тот, кто первым полностью окружит пчелиную матку соперника.

## 📦 Скачать

Готовые сборки для всех платформ лежат на странице [**Releases**](https://github.com/toniess/Hive/releases).
Сборки из последнего коммита — во вкладке [**Actions**](https://github.com/toniess/Hive/actions/workflows/build.yml) (раздел *Artifacts* внутри запуска).

| Платформа | Файл | Запуск |
|---|---|---|
| 🪟 Windows | `Hive-windows-x64.zip` | Распаковать и запустить `Hive.exe` |
| 🍎 macOS | `Hive-macos.dmg` | Открыть образ и перетащить `Hive.app` в «Программы» |
| 🐧 Linux | `Hive-linux-x86_64.AppImage` | `chmod +x Hive-linux-x86_64.AppImage && ./Hive-linux-x86_64.AppImage` |

> [!NOTE]
> Сборки не подписаны сертификатом разработчика, поэтому при первом запуске система предупредит:
> - **macOS** — правый клик по `Hive.app` → «Открыть». На macOS 15+: «Системные настройки → Конфиденциальность и безопасность → Всё равно открыть».
> - **Windows** — в окне SmartScreen нажмите «Подробнее» → «Выполнить в любом случае».

## 🛠 Сборка из исходников

**Что нужно:** Qt 6 (модуль Qt Quick) и компилятор с поддержкой C++17.

```bash
git clone https://github.com/toniess/Hive.git
cd Hive
mkdir build && cd build
qmake ../HiveQML.pro
make            # на Windows: nmake или jom
```

<div align="center">
<sub>Hive — настольная игра Джона Йанни (Gen42 Games). Этот проект — неофициальная фанатская реализация.</sub>
</div>
