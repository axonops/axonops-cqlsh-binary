# setup.py
from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize
from Cython.Distutils import build_ext
import os, sys

# Find all Python files recursively
def find_python_files(directory):
    python_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if 'setup.py' in file or file == '__init__.py':
                continue
            if file.endswith('.py'):
                if "-" in file:
                    print(f"ERROR: You cannot cpythonize a file with '-' in its name: {file}")
                    sys.exit(1)
                path = os.path.join(root, file)
                module = path[:-3].replace(os.path.sep, '.')
                python_files.append(module)
    return python_files

cassandra_files = find_python_files('cassandra')
cqlshlib_files = find_python_files('cqlshlib')
wcwidth_files = find_python_files('wcwidth')

# Define extensions for each Python file
ext_modules = [
    Extension(module, [module.replace('.', os.path.sep) + '.py'])
    for module in cqlshlib_files + cassandra_files + wcwidth_files
]
# Add the main script
ext_modules.append(
    Extension('cqlsh_main', ['cqlsh.py']),
)

setup(
    name="cqlsh",
    ext_modules=cythonize(ext_modules, compiler_directives={
        'language_level': 3,
        'embedsignature': True
    }),
    include_package_data=True,
    packages=find_packages(where='.'),
    cmdclass={'build_ext': build_ext},
    script_args=['build_ext'],
    py_modules=['cassandra', 'cqlshlib', 'wcwidth', 'encodings'],
    # Additional metadata
    author="AxonOps Limited",
    author_email="support@axonops.com",
    description="cqlsh is a Python-based command-line client for running CQL commands on a cassandra cluster.",
    keywords=["cql", "cassandra", "cqlsh", "axonops"],
    url="https://bitbucket.org/digitalisio/axonops-cqlsh-binary/",
)

