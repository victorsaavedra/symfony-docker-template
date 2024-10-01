<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\Controller;

use App\SharedKernel\Infrastructure\RequestDTOInterface;
use App\SharedKernel\Infrastructure\ResponseDTOInterface;

interface ControllerInterface
{
    public function handleResponse(RequestDTOInterface $request): ResponseDTOInterface;
}
