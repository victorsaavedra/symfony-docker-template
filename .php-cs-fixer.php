<?php

$finder = (new PhpCsFixer\Finder())
    ->in(__DIR__)
    ->exclude(['var', 'public', 'tests', 'templates', 'migrations', 'infrastructure', 'assets', 'bin', 'vendor'])
;

return (new PhpCsFixer\Config())
    ->setRules([
        '@Symfony' => true,
    ])
    ->setFinder($finder)
;
