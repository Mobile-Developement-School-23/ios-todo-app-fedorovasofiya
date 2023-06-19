#  ToDo App

Правила конвертации в JSON и обратно:
- Если отсутствуют или некорректно заданы обязательные параметры, то при парсинге возвращается nil
- Если неправильно заданы необязательные параметры, то они будут равны nil


Правила конвертации в CSV и обратно:
- Если отсутствуют или некорректно заданы обязательные параметры, то при парсинге возвращается nil
- Если неправильно заданы необязательные параметры, то они будут равны nil
- Столбцы обязательно указываются в таком порядке: id; text; importance; deadline; isDone; creationDate; modificationDate
- Используемые разделители столбцов и строк в csv-файле указаны в расширении TodoItem
- Булевое значение сохраняется как Int (может принимать значения "1" или "0")