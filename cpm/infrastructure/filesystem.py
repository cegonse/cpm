import os


class Filesystem:
    def create_directory(self, name):
        os.mkdir(name)

    def create_file(self, name, contents=''):
        with open(name, 'w') as f:
            f.write(contents)

    def directory_exists(self, name):
        return os.path.exists(name) and os.path.isdir(name)
