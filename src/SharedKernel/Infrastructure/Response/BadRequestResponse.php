<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\Response;

use App\SharedKernel\Infrastructure\ResponseDTOInterface;

class BadRequestResponse implements ResponseDTOInterface
{
    public function __construct(
        public string $message,
        public int $statusCode,
    ) {
    }
}
