<?php

declare(strict_types=1);

namespace App\SharedKernel\Infrastructure\Response;

use App\SharedKernel\Infrastructure\ResponseDTOInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;

class SymfonyJsonApiResponse implements JsonApiResponseInterface
{
    public function ok(ResponseDTOInterface $responseDTO): JsonResponse
    {
        return new JsonResponse('ok', Response::HTTP_OK);
    }

    public function badRequest(BadRequestResponse $responseDTO): JsonResponse
    {
        return new JsonResponse($responseDTO->message, Response::HTTP_BAD_REQUEST);
    }
}
