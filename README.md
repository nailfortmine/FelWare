[+] Исправления
World Color: Теперь корректно изменяет цвет всех объектов типа BasePart в Workspace, исключая модели игроков, чтобы не затрагивать персонажей.
Third Person: Завершена функция с плавной работой камеры от третьего лица, используя HumanoidRootPart и Head для точного позиционирования.
[+] Anti-Aim
Добавлены новые режимы Yaw:
SineWave: Синусоидальное изменение угла по горизонтали.
Bounce: Угол "прыгает" в пределах заданного диапазона.
Добавлены новые режимы Pitch:
SinePitch: Синусоидальное изменение угла по вертикали.
Flip: Переворот угла на 180° каждую секунду.
Новые настройки:
Anti-Aim Range: Диапазон углов (30–180° с шагом 30) для режимов Jitter, FakeLag, SineWave, Bounce, Random, SinePitch.
Сохранены Speed (0.5–5) и Offset (-90–90).
Улучшена рандомизация углов с опцией Anti-Aim Random.
[+] Визуальные эффекты
Chams: Прозрачные обводки врагов с помощью BoxHandleAdornment, цвет совпадает с ESP.
Wireframe: Каркасное отображение врагов через WireframeHandleAdornment.
Glow: Светящийся эффект от HumanoidRootPart врагов с настройкой цвета ESP.
Hitmarker: Крест на экране при попадании (активируется с TriggerBot, SilentAim, KillAura, MassKill).
Tracer Color: Настраиваемый цвет трассеров (Red, Green, Blue, Yellow, Purple).
[/] GUI
Дизайн:
Размер увеличен до 500x600 для большего пространства.
Более темная тема с градиентами (от 35,35,40 до 15,15,20).
Уменьшена толщина полос прокрутки (с 8 до 6).
Кнопки увеличены до 40 пикселей в высоту.
Добавлены тень под рамкой и более плавные углы (CornerRadius 10).
Новые элементы:
Вкладка ESP: кнопки для Chams, Wireframe, Glow.
Вкладка Aimbot: кнопка для Hitmarker.
Вкладка Misc: настройки Anti-Aim Range.
Вкладка Settings: настройка Tracer Color.
[-] MassKill
Функция осталась без изменений в плане логики: массово атакует всех врагов в радиусе действия с рандомизацией позиций для обхода античита.
Добавлена поддержка Hitmarker для визуального подтверждения попаданий.
Полное описание скрипта
Структура скрипта
Импорт сервисов: Используются стандартные сервисы Roblox (Players, UserInputService, RunService, Lighting, Camera, TweenService) и Drawing API для FOV-круга.
Настройки: Объект settings содержит параметры GUI, визуальных эффектов, Anti-Aim и мира (цвет, яркость, туман).
Флаги: Переменные для включения/выключения функций (ESP, Aimbot, Anti-Aim, визуальные эффекты и т.д.).
Переменные: Параметры для Aimbot (FOV, Smoothing, Bone), Anti-Aim (Yaw, Pitch, Speed, Offset, Range), ESP (Mode, Color) и другие.
GUI
Создание:
Главное окно (MainFrame) с градиентом, тенью и обводкой.
Заголовок "FelWare" с крупным шрифтом.
Кнопка закрытия с анимацией.
Вкладки: ESP, Aimbot, Misc, Settings с кнопками переключения.
Анимация: Открытие/закрытие через TweenService с клавишей Insert.
Вкладки:
ESP: Управление ESP (Box/Highlight), цветом, Team Check, Tracer, Chams, Wireframe, Glow.
Aimbot: Управление Aimbot (режимы, FOV, Smoothing, Bone), Wall Check, TriggerBot, Silent Aim, Hitmarker.
Misc: Множество функций (Crosshair, Speed Hack, Bunnyhop, Anti-Aim с настройками, Wallbang и т.д.).
Settings: Кастомизация GUI (цвет, размер шрифта), мира (World Color, Ambient, Brightness, Fog), Tracer Color.
Функции
ESP: Отображает врагов через Box или Highlight, добавлены Chams, Wireframe, Glow.
Aimbot: Легит и Rage режимы с настраиваемым FOV и Smoothing, поддержка Wall Check.
TriggerBot: Автоматическая стрельба при наведении на врага.
Silent Aim: Скрытая стрельба по ближайшему врагу с рандомизацией.
Anti-Aim: Множество режимов (Spin, Static, Jitter, FakeLag, Reverse, SineWave, Bounce для Yaw; Up, Down, Random, JitterPitch, FakeUp, SinePitch, Flip для Pitch) с настройками Speed, Offset, Range.
Speed Hack: Увеличение скорости передвижения.
Bunnyhop/Infinite Jump: Автоматические прыжки.
No Recoil: Устранение отдачи.
Infinite Ammo: Бесконечные патроны (9999).
Fast Shot: Ускоренная стрельба (FireRate 0.01, анимации x5).
Fast Round: Ускорение раундов (RoundTime = 1).
Wallbang: Прохождение пуль через стены.
Fly: Полет с управлением (Space/LeftControl).
Third Person: Вид от третьего лица с настраиваемой дистанцией.
Bullet Tracer: Трассеры пуль с настраиваемым цветом.
Kill Aura: Атака врагов в радиусе 10 studs.
Rapid Fire: Быстрая автоматическая стрельба.
Smooth Reload: Плавная перезарядка с уменьшением скорости.
TP Kill: Телепортация к врагам с атакой.
Mass Kill: Массовая атака всех врагов.
Crash Server: Спам запросов для перегрузки сервера.
Визуальные эффекты
Crosshair: Простой крест в центре экрана.
Hitmarker: Визуальный индикатор попадания (крест на 0.3 секунды).
Chams: Обводка врагов.
Wireframe: Каркас врагов.
Glow: Свет от врагов.
Tracers: Линии от центра экрана к врагам.
Основной цикл
RunService.RenderStepped: Обновляет все функции каждый кадр с обработкой ошибок через pcall.
Players.PlayerAdded/PlayerRemoving: Динамическое обновление ESP для новых/удаленных игроков.
Использование
Запуск через инжектор (например, Synapse X).
Открытие GUI клавишей Insert.
Настройка через интерфейс.
