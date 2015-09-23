#pragma once

#include <QtGui>

#include "ui_qt-test.h"

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    MainWindow(QWidget* parent = 0):
        QMainWindow(parent),
        ui(new Ui::MainWindow)
    {
        ui->setupUi(this);
    }

    ~MainWindow() {
        delete ui;
    }

signals:
    void testSignal();

public slots:
    void testSlot() {
    }

private:
    Ui::MainWindow* ui;
};
