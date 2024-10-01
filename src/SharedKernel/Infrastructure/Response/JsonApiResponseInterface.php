<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\Response;

use App\SharedKernel\Infrastructure\ResponseDTOInterface;
use Symfony\Component\HttpFoundation\JsonResponse;

interface JsonApiResponseInterface
{
    public function ok(ResponseDTOInterface $responseDTO): JsonResponse;

    public function badRequest(BadRequestResponse $responseDTO): JsonResponse;
}
