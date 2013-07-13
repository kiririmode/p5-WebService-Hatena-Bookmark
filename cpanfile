requires 'perl', '5.008001';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Flatten';
    requires 'Test::Exception';
    requires 'Term::ReadLine';
};

on 'runtime' => sub {
    requires 'XML::Atom::Client';
    requires 'XML::Atom::Entry';
    requires 'Encode';
    requires 'Carp';
    requires 'constant';
};

