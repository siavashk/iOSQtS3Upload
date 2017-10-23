#pragma once
#include <QString>

class QFile;
class QString;

struct S3Info
{
    S3Info(QString x_amz_date, QString x_amz_credential, QString x_amz_algorithm, QString x_amz_signature, QString key, QString policy);
    QString x_amz_date_;
    QString x_amz_credential_;
    QString x_amz_algorithm_;
    QString x_amz_signature_;
    QString key_;
    QString policy_;
};

void makeBody(const QString& resultFilePath, const QString& binaryFilePath, const QString& boundary, const S3Info& s3Info);
