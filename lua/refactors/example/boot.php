<?php

namespace Examples;

class Exampe
{
    protected static function boot()
    {
        static::addGlobalScope(new TeamScope);
        static::observe(new UuidObserver);
        static::observe(new TeamObserver);
        static::observe(new ActivityObserver);
    }

    public function fwee() {}
}
