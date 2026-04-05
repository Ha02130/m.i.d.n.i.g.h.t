import sys
from contextlib import contextmanager
from typing import Any, Callable, cast

from PySide6.QtCore import QtMsgType, qInstallMessageHandler
from PySide6.QtWidgets import QApplication

from .embedded_assets import get_logo_icon
from .ui.main_window import MainWindow


_QT_DPI_WARNING_PREFIXES = (
    "SetProcessDpiAwarenessContext() failed:",
    "Qt's default DPI awareness context is DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2.",
)
_QtMessageHandler = Callable[[Any, Any, str], None]


def _should_suppress_qt_startup_warning(message: str) -> bool:
    return any(message.startswith(prefix) for prefix in _QT_DPI_WARNING_PREFIXES)


@contextmanager
def _suppress_known_qt_startup_warnings():
    previous_handler: _QtMessageHandler | None = None

    def message_handler(msg_type: Any, context: Any, message: str) -> None:
        if msg_type == QtMsgType.QtWarningMsg and _should_suppress_qt_startup_warning(message):
            return
        if previous_handler is not None:
            previous_handler(msg_type, context, message)
            return
        print(message, file=sys.stderr)

    previous_handler = cast(_QtMessageHandler | None, qInstallMessageHandler(message_handler))
    try:
        yield
    finally:
        qInstallMessageHandler(previous_handler)


def create_qapplication(argv: list[str]) -> QApplication:
    with _suppress_known_qt_startup_warnings():
        existing_app = QApplication.instance()
        if isinstance(existing_app, QApplication):
            return existing_app
        return QApplication(argv)


class Termnal:

    def __init__(self) -> None:
        self.app: QApplication | None = None
        self.window: MainWindow | None = None

    def run(self) -> int:
        self.app = create_qapplication(sys.argv)
        self.app.setWindowIcon(get_logo_icon())
        self.window = MainWindow()
        self.window.show()
        return self.app.exec()
