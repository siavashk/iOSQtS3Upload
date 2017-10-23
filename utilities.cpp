#include "utilities.h"
#include <QFile>
#include <QString>

S3Info::S3Info(QString x_amz_date, QString x_amz_credential, QString x_amz_algorithm,
    QString x_amz_signature, QString key, QString policy)
    : x_amz_date_(x_amz_date)
    , x_amz_credential_(x_amz_credential)
    , x_amz_algorithm_(x_amz_algorithm)
    , x_amz_signature_(x_amz_signature)
    , key_(key)
    , policy_(policy)
{
}

void writeStartBoundary(QFile& writer, const QString& boundary)
{
    const char* boundaryPtr = boundary.toUtf8().data();
    writer.write(boundaryPtr, qstrlen(boundaryPtr));
    
    const char* cr = QString("\r\n").toUtf8().data();
    writer.write(cr, qstrlen(cr));
}

void writeField(QFile& writer, const QString& name, const QString& value, const QString& boundary)
{
    auto header = QString("Content-Disposition: form-data; name=\"%1\"\r\n").arg(name);
    
    const char* headerPtr = header.toUtf8().data();
    writer.write(headerPtr, qstrlen(headerPtr));
    
    const char* cr = QString("\r\n").toUtf8().data();
    writer.write(cr, qstrlen(cr));
    
    const char* valuePtr = value.toUtf8().data();
    writer.write(valuePtr, qstrlen(valuePtr));
    
    writer.write(cr, qstrlen(cr));
    
    const char* boundaryPtr = boundary.toUtf8().data();
    writer.write(boundaryPtr, qstrlen(boundaryPtr));
    
    writer.write(cr, qstrlen(cr));
}

void writeBinaryField(QFile& writer, const QString& binaryFilePath, const QString& boundary)
{
    const QString header("Content-Disposition: form-data; name=\"file\"\r\nContent-Type: application/macbinary\r\n");
    
    const char* headerPtr = header.toUtf8().data();
    writer.write(headerPtr, qstrlen(headerPtr));
    
    const char* cr = QString("\r\n").toUtf8().data();
    writer.write(cr, qstrlen(cr));

    QFile reader(binaryFilePath);
    reader.open(QIODevice::ReadOnly);
    
    writer.write((char*) reader.map(0, reader.size()), reader.size()); //Copies all data
    reader.close();
    
    writer.write(cr, qstrlen(cr));
}

void writeEndBoundary(QFile& writer, const QString& boundary)
{
    const char* boundaryPtr = boundary.toUtf8().data();
    writer.write(boundaryPtr, qstrlen(boundaryPtr));
    
    const char* endPtr = QString("--").toUtf8().data();
    writer.write(endPtr, qstrlen(endPtr));
}

void makeBody(const QString& resultFilePath, const QString& binaryFilePath, const QString& boundary, const S3Info& s3Info)
{
    QFile writer(resultFilePath);
    writer.open(QIODevice::WriteOnly);
    
    writeStartBoundary(writer, boundary);
    
    writeField(writer, "Policy", s3Info.policy_, boundary);
    writeField(writer, "key", s3Info.key_, boundary);
    writeField(writer, "X-Amz-Date", s3Info.x_amz_date_, boundary);
    writeField(writer, "X-Amz-Signature", s3Info.x_amz_signature_, boundary);
    writeField(writer, "X-Amz-Credential", s3Info.x_amz_credential_, boundary);
    writeField(writer, "X-Amz-Algorithm", s3Info.x_amz_algorithm_, boundary);
    
    writeBinaryField(writer, binaryFilePath, boundary);
    
    writeEndBoundary(writer, boundary);
}
